import json
import os
import random
import re
import sys
import glob
import subprocess
from time import sleep
from typing import Optional, TypedDict
from bs4 import BeautifulSoup
import requests

URL_BASE = 'https://www.allaboutbirds.org'

URL = f'{URL_BASE}/guide/browse/shape/Ducks'

headers = {
  'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:144.0) Gecko/20100101 Firefox/144.0'
}

SIZE_REPLACE_REGEX = re.compile(r'-(\d+)px')

def request_delay() -> None:
  sleep(random.uniform(3, 10))

class Duck:
  class DuckManifest(TypedDict):
    species_name: str
    scientific_name: str
    order: str
    family: str
    # Links
    basic_description: Optional[str]
    cool_facts: Optional[list[str]]
    find_this_bird: Optional[str]
    images: Optional[list[str]]

  def __init__(self) -> None:
    self.species_name = None
    self.scientific_name = None
    self.order = None
    self.family = None
    self.basic_description = None
    self.cool_facts = None
    self.find_this_bird = None
    self.images = None
    self.videos = None

  def dump(self) -> DuckManifest:
    if any(v is None for v in [self.species_name, self.scientific_name, self.order, self.family]):
      raise ValueError("Species name or scientific name is missing.")
    duck_name_simplified = self.species_name.replace(' ', '_').replace("'", '')
    duck_dir = os.path.join('ducks', duck_name_simplified)
    os.makedirs(duck_dir, exist_ok=True)
    
    ans = {
      'species_name': self.species_name,
      'scientific_name': self.scientific_name,
      'order': self.order,
      'family': self.family,
      # 'basic_description': None,
      # 'cool_facts': None,
      # 'find_this_bird': None,
      # 'images': None,
    }

    if self.basic_description is not None:
      ans['basic_description'] = f'{duck_name_simplified}/basic_description.txt'
      with open(os.path.join(duck_dir, 'basic_description.txt'), 'w') as desc_file:
        desc_file.write(self.basic_description)

    if self.cool_facts is not None:
      ans['cool_facts'] = f'{duck_name_simplified}/cool_facts.txt'
      with open(os.path.join(duck_dir, 'cool_facts.txt'), 'w') as facts_file:
        for fact in self.cool_facts:
          facts_file.write(fact + '\n')

    if self.find_this_bird is not None:
      ans['find_this_bird'] = f'{duck_name_simplified}/find_this_bird.txt'
      with open(os.path.join(duck_dir, 'find_this_bird.txt'), 'w') as find_file:
        find_file.write(self.find_this_bird)

    if self.images is not None:
      ans['images'] = []
      for i, image in enumerate(self.images):
        request_delay()
        img_data = requests.get(image, headers=headers).content
        img_name = f'image_{i}.jpg'
        ans['images'].append(f'{duck_name_simplified}/{img_name}')
        with open(os.path.join(duck_dir, img_name), 'wb') as img_file:
          img_file.write(img_data)
      if self.videos is not None:
        ans['videos'] = []
        for video in self.videos:
          if video.startswith('ducks/'):
            video = video[6:]
          ans['videos'].append(video)
    return ans

  # def __str__(self):
  #   return f"{self.species_name} ({self.scientific_name}) - Order: {self.order}, Family: {self.family}, Images: {len(self.images) if self.images else None}\nDescription:\n{self.basic_description}\nCool Facts ({len(self.cool_facts) if self.cool_facts else None}):\n" + "\n".join(self.cool_facts) + f"\nFind This Bird:\n{self.find_this_bird}"

  def specie_info(self, soup: BeautifulSoup) -> bool:
    species_info = soup.find('div', class_='species-info')
    if not species_info:
      return False
    self.species_name = species_info.find('span', class_='species-name').get_text(strip=True)
    self.scientific_name = species_info.find('em').get_text(strip=True)
    additional_info = species_info.find('ul', class_='additional-info')
    if additional_info:
      for li in additional_info.find_all('li'):
        title = li.find('span').text.strip().lower()
        if title == 'order:':
            self.order = li.get_text(strip=True).replace(title, '').strip().split(':')[1]
        elif title == 'family:':
          self.family = li.get_text(strip=True).replace(title, '').strip().split(':')[1]
    return True

  def media(self, soup: BeautifulSoup) -> bool:
    media_section = soup.find('div', class_='hero')
    if not media_section:
      return False
    self.images = []
    img_tags = media_section.find_all('img')
    for img in img_tags:
      img_url = img.get('data-interchange')
      if not img_url:
        print("Image tag without src attribute.")
        continue
      img_url = img_url.strip('[]')
      img_url = img_url.split(',')[0].strip().strip('"')
      if not SIZE_REPLACE_REGEX.search(img_url):
        print(f"Unexpected image URL format: {img_url}")
        return False
      self.images.append(SIZE_REPLACE_REGEX.sub('-720px', img_url))
    return True

  def video_media(self, url: str, target: str = '.') -> bool:
    if url.endswith('/'):
      url = url[:-1]
    if url.endswith('overview'):
      url = url[:-8]
    if url.endswith('/'):
      url = url[:-1]
    try:
      subprocess.run(['yt-dlp', '-o', f'{target}/video%(playlist_index)d.mp4', f'{url}/photo-gallery'], check=True)
    except Exception as e:
      print(f"Failed to download video: {e}")
      return False
    
    self.videos = glob.glob(os.path.join(target, '*.mp4'))
    
    return True
  
  def get_basic_info(self, soup: BeautifulSoup) -> bool:
    info_section = soup.find('h2', class_='overview')
    if not info_section:
      return False
    info_section = info_section.parent
    self.basic_description = info_section.find('p').get_text(strip=True)
    return True

  def get_accordion(self, soup: BeautifulSoup) -> bool:
    accordion_section = soup.find('ul', class_='accordion')
    if not accordion_section:
      print("No accordion section found.")
      return False
    ul = accordion_section.find('ul')
    if not ul:
      print("No list found in accordion section.")
      return False
    self.cool_facts = []
    for li in ul.find_all('li'):
      self.cool_facts.append(li.get_text(strip=True))
    return True

  def get_find_this_bird(self, soup: BeautifulSoup) -> bool:
    find_section = soup.find('h2', string='Find This Bird')
    if not find_section:
      return False
    find_section = find_section.parent
    self.find_this_bird = find_section.find('p').get_text(strip=True)
    return True

def main() -> int:
  response = requests.get(URL, headers=headers)
  if response.status_code != 200:
    print(f"Failed to retrieve webpage: {response.status_code}")
    return 1
  duck_manifest: list[dict] = []
  soup = BeautifulSoup(response.content, 'html.parser')
  bird_elements = soup.find_all('div', class_='species-card')
  for bird in bird_elements:
    a = bird.find('a')
    if not a:
      print("No link found for bird species.")
      continue
    request_delay()
    url = f"{URL_BASE}{a['href']}"
    overview = requests.get(url, headers=headers)
    if overview.status_code != 200:
      print(f"Failed to retrieve bird overview: {overview.status_code}")
      continue
    overview_soup = BeautifulSoup(overview.content, 'html.parser')
    duck = Duck()
    if not duck.specie_info(overview_soup):
      print("Failed to extract species info.")
      continue
    if not duck.media(overview_soup):
      print("Failed to extract media info.")
    if not duck.video_media(url, target=os.path.join('ducks', duck.species_name.replace(' ', '_').replace("'", ''))):
      print("Failed to download video media.")
    if not duck.get_basic_info(overview_soup):
      print("Failed to extract basic info.")
    if not duck.get_accordion(overview_soup):
      print("Failed to extract accordion info.")
    if not duck.get_find_this_bird(overview_soup):
      print("Failed to extract 'Find This Bird' info.")
    # print(duck)
    # for img_url in duck.images:
    #   print(f"Image URL: {img_url}")
    duck_manifest.append(duck.dump())
    with open('ducks/manifest.json', 'w') as manifest_file:
      json.dump(duck_manifest, manifest_file, indent=2)

  return 0

if __name__ == "__main__":
  sys.exit(main())
