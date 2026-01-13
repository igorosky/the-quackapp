# TheQuackApp

A SwiftUI iOS application for exploring and learning about different duck species from around the world.

## Features

### Home Screen
- **Duck of the Day**: Discover a new duck species every day with automatic daily rotation
- **Quick Navigation**: Easy access to duck search and app settings
- **Beautiful Gradients**: Eye-catching gradient backgrounds with enhanced text visibility in both light and dark modes

#### Home Screen Screenshot
<p align="center">
  <img src="https://github.com/igorosky/the-quackapp/blob/a3360759f2a508f75c8652ba5cedb8cd0632ea48/screenshots/ss_home.png" alt="Home Screen Screenshot" width="30%"/>
</p>

### Duck Discovery
- **Smart Search**: Search ducks by name with real-time filtering
- **Region Filtering**: Filter ducks by geographical regions:
  - North America
  - South America
  - Europe
  - Asia
  - Africa
  - Oceania
  - Antarctica
- **Comprehensive List View**: Browse all available duck species with images and regional information

#### Duck Discovery Screenshot
<p align="center">
  <img src="https://github.com/igorosky/the-quackapp/blob/a3360759f2a508f75c8652ba5cedb8cd0632ea48/screenshots/ss_search.png" alt="Duck Discovery Screenshot" width="30%"/>
</p>

### Duck Details
- **Rich Media Gallery**: View images, videos, and sounds for each duck species
- **Detailed Information**: 
  - Common and scientific names
  - Short and detailed descriptions
  - Cool facts about the species
  - "Find This Bird" section with habitat and identification tips
- **Interactive Media Player**: Built-in audio and video playback capabilities
- **Media Grid View**: Browse all media in an organized grid layout
  
#### Duck Details Screenshot
<p align="center">
  <img src="https://github.com/igorosky/the-quackapp/blob/518d060b05b665405334f8f493b74257d241e7c4/screenshots/ss_details.png" alt="Duck Details Screenshot" width="30%"/>
</p>

#### Duck Images Grid Screenshot
<p align="center">
  <img src="https://github.com/igorosky/the-quackapp/blob/a3360759f2a508f75c8652ba5cedb8cd0632ea48/screenshots/ss_mediagrid.png" alt="Duck Images Grid Screenshot" width="30%"/>
</p>

### Settings
- **Server Configuration**: Configure custom server URL for duck data
- **Scientific Names**: Toggle display of scientific names throughout the app
- **Dark Mode**: Switch between light and dark themes
- **Persistent Preferences**: All settings are saved locally

#### Settings Screenshots
<p align="center">
  <img src="https://github.com/igorosky/the-quackapp/blob/a3360759f2a508f75c8652ba5cedb8cd0632ea48/screenshots/ss_settings.png" alt="Settings Screenshot Dark mode" width="30%"/>
  &nbsp;&nbsp;
  <img src="https://github.com/igorosky/the-quackapp/blob/e02aea68b8f763d8f88458a271659f5715158cc5/screenshots/ss_settings_light.png" alt="Settings Screenshot Light mode" width="30%"/>
  <br>
  <em>Dark mode (left) and Light mode (right)</em>
</p>

## Technical Stack

- **Framework**: SwiftUI
- **Minimum iOS Version**: iOS 15.0+
- **Media Playback**: AVKit and AVFoundation
- **Data Persistence**: UserDefaults for settings
- **Image Loading**: Async image loading with caching
- **Testing**: XCTest framework for unit, integration, and UI tests

## Project Structure

```
TheQuackApp/
├── App/
│   └── TheQuackAppApp.swift        # Main app entry point
├── Views/
│   ├── Home/
│   │   ├── HomeView.swift          # Home screen with Duck of the Day
│   │   └── DuckOfTheDay.swift      # Daily duck rotation logic
│   ├── Ducks/
│   │   ├── DucksListView.swift     # Search and browse ducks
│   │   └── DuckDetailView.swift    # Detailed duck information
│   ├── Media/
│   │   ├── MediaView.swift         # Media player view
│   │   ├── MediaImage.swift        # Async image loader component
│   │   └── MediaGridView.swift     # Media gallery grid
│   ├── Settings/
│   │   └── SettingsView.swift      # App settings
│   └── ContentView.swift           # Root navigation view
├── Models/
│   ├── Duck.swift                  # Main duck data model
│   ├── DuckManifestItem.swift      # Duck manifest structure
│   ├── DucksStore.swift            # Duck data store and network layer
│   ├── Region.swift                # Geographical region enumeration
│   ├── Configuration.swift         # Server configuration
│   └── AppSettings.swift           # User preferences manager
├── Theme/
│   └── Theme.swift                 # Color theme definitions
├── Assets.xcassets/                # App assets and colors
└── Tests/
    ├── UnitTests.swift             # Unit tests for models and data types
    ├── IntegrationTests.swift      # Integration tests
    └── UITests.swift               # UI automation tests
```

## Key Components

### Models
- **Duck**: Main data model with images, videos, sounds, and descriptions
- **DuckManifestItem**: Structure for parsing duck data from server manifest
- **Region**: Enumeration of geographical regions
- **DucksStore**: ObservableObject that fetches and manages duck data from server
- **Configuration**: Server configuration model
- **AppSettings**: User preferences and settings manager

### Theme System
- Custom color palette with support for light/dark modes
- Gradient backgrounds (bgTop, bgBottom)
- Card backgrounds with subtle transparency
- Accent colors for buttons and interactive elements

### Media Handling
- **MediaImage**: Component for loading images from URLs or local assets
- **MediaView**: Full-screen media viewer with navigation
- **MediaGridView**: Grid layout for browsing multiple media items
- Support for images, videos, and audio files

## Server Integration

The app fetches duck data from a configurable server endpoint. The server should provide a `manifest.json` file with the following structure:

```json
[
  {
    "species_name": "Mallard",
    "scientific_name": "Anas platyrhynchos",
    "basic_description": "A common duck species...",
    "cool_facts": "Interesting facts...",
    "find_this_bird": "Habitat and identification info...",
    "regions": ["North America", "Europe", "Asia"],
    "images": ["image1.jpg", "image2.jpg"],
    "videos": ["video1.mp4"],
    "sounds": ["sound1.mp3"]
  }
]
```

Media files should be accessible via relative URLs from the base server URL.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/igorosky/the-quackapp.git
   ```

2. Open the project in Xcode:
   ```bash
   cd the-quackapp/TheQuackApp
   open TheQuackApp.xcodeproj
   ```

3. Build and run the project on your iOS device or simulator (requires Xcode 13.0+)

## Configuration

### Setting Up a Server
1. Launch the app
2. Navigate to Settings (gear icon on home screen)
3. Enter your server base URL in the "Server Base URL" field
4. The app will automatically fetch duck data from your server

### Default Behavior
- If no server is configured or the server is unavailable, the app will display sample duck data
- Settings are persisted across app launches

## UI/UX Features

- **Smooth Animations**: Spring animations and transitions throughout the app
- **Loading States**: Progress indicators during data fetching
- **Error Handling**: Graceful fallbacks for missing data or network issues
- **Empty States**: Informative messages when no content is available

## License

*[to be specified]*
