# Nextgen Smart Home Ecosystem

A comprehensive IoT smart home management platform featuring real-time device control, multi-user access management, and energy consumption monitoring across web and mobile platforms.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [API Documentation](#api-documentation)
- [Features](#features)
- [Development](#development)

## Overview

Nextgen is a distributed IoT platform that enables users to manage smart home devices through a centralized system. The platform supports multiple device types including smart lights, thermostats, cameras, locks, and smart plugs. It features a hub-based architecture where local hubs manage devices on private networks while syncing with a central cloud backend for remote access and analytics.

### Key Highlights

- **Multi-tier Architecture**: Client → Backend → Hub → Devices
- **Real-time Communication**: MQTT + WebSocket for instant updates
- **Cross-platform Support**: Web (Next.js), Mobile (Flutter)
- **Role-based Access**: Manager (owner) and Dweller (guest) roles
- **Energy Monitoring**: Per-device power consumption tracking
- **Hybrid Storage**: Local hub storage + cloud database

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                             │
├──────────────────┬──────────────────┬──────────────────────┤
│   Web Frontend   │  Mobile App      │  Admin Dashboard     │
│   (Next.js)      │  (Flutter)       │  (Next.js)           │
└────────┬─────────┴────────┬─────────┴──────────┬───────────┘
         │                  │                     │
         └──────────────────┼─────────────────────┘
                            │ HTTP/WebSocket
                            │
┌───────────────────────────▼──────────────────────────────────┐
│               APPLICATION LAYER                              │
├─────────────────────────────────────────────────────────────┤
│  FastAPI Backend (Port 8000)                                 │
│  • Authentication & Authorization (JWT)                      │
│  • Home & Device Management                                  │
│  • WebSocket for Real-time Updates                           │
│  • Redis Pub/Sub for State Changes                           │
├─────────────────────────────────────────────────────────────┤
│  Hub Service (Port 8010)                                      │
│  • Local Device Control (REST API)                            │
│  • MQTT Broker Interface                                     │
│  • Device Data Collection & Storage                           │
├─────────────────────────────────────────────────────────────┤
│  Listener Service                                            │
│  • MQTT Event Subscriber                                     │
│  • Backend Sync via HTTP                                     │
└──────────┬──────────────────────┬─────────────────────────┬──┘
           │                      │                         │
          MQTT              HTTP Requests            Redis Pub/Sub
           │                      │                         │
┌──────────▼──────────────────────┴─────────────────────────▼──┐
│                    DEVICE LAYER                               │
├────────────────────────────────────────────────────────────┤
│  Smart Devices (MQTT Protocol)                             │
│  • Smart Lights (RGB, Brightness)                          │
│  • Thermostats (Temperature, Fan Control)                  │
│  • Cameras (Frame Capture, Video Recording)                │
│  • Smart Locks (Lock/Unlock)                               │
│  • Smart Plugs (Power Monitoring)                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    DATA LAYER                               │
├─────────────────────────────────────────────────────────────┤
│  • MongoDB Atlas (Users, Homes, Devices, Hubs)              │
│  • Redis (Caching & Pub/Sub Messaging)                      │
│  • Local Storage (Device Logs, Video Recordings)            │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```
Device State Change
    ↓
Publishes to MQTT (devices/{device_id}/state)
    ↓
Hub Receives & Stores Locally
    ↓
Listener Forwards to Backend (HTTP POST /device_update)
    ↓
Backend Publishes to Redis ("device_updates")
    ↓
WebSocket Broadcasts to Connected Clients
    ↓
Frontend/Mobile UI Updates in Real-time
```

## Technology Stack

### Backend

- **Framework**: FastAPI (Python 3.x)
- **Server**: Uvicorn ASGI
- **Database**: MongoDB Atlas (Cloud)
- **Cache & Messaging**: Redis (Pub/Sub)
- **Authentication**: JWT tokens, Werkzeug password hashing
- **MQTT**: paho-mqtt for device communication
- **Additional**: python-dotenv, httpx, opencv-python, numpy

### Frontend (Web)

- **Framework**: Next.js 15.2.1 with Turbopack
- **UI Library**: React 19.0.0 with TypeScript
- **Styling**: Tailwind CSS 4.0, Emotion
- **Components**: MUI (Material-UI) v5/v6, MUI X-Charts
- **State Management**: MobX + MobX-React, React Query
- **HTTP Client**: Axios
- **Authentication**: JWT tokens (jwt-decode)
- **Integrations**: Stripe, Google OAuth, reCAPTCHA

### Mobile (Flutter)

- **Framework**: Flutter (Dart SDK ^3.6.0)
- **HTTP**: http package
- **Real-time**: web_socket_channel
- **Charts**: fl_chart
- **State**: scoped_model
- **Storage**: shared_preferences
- **UI**: Lottie animations, Material Design
- **Additional**: mobile_scanner (QR), permission_handler, webview_flutter

### IoT Devices

- **Protocol**: MQTT (publish/subscribe)
- **Computer Vision**: OpenCV (cv2) for cameras
- **Image Processing**: numpy, base64 encoding
- **Client**: paho-mqtt

## Project Structure

```
nextgen/
├── backend/                    # Main FastAPI backend server
│   ├── app/                    # Application initialization
│   ├── api/                    # API route controllers
│   │   ├── authentication.py   # Auth endpoints
│   │   ├── management.py       # Home management
│   │   └── devices.py          # Device control
│   ├── repositories/           # Data access layer
│   │   ├── userManager.py      # User CRUD
│   │   ├── homeManager.py      # Home CRUD
│   │   └── deviceManager.py    # Device CRUD
│   ├── model/                  # Pydantic models
│   │   └── deviceModel.py      # Data schemas
│   ├── services/               # Business logic
│   │   ├── send_command.py     # Device commands
│   │   └── daily_usage.py      # Energy calculations
│   ├── main.py                 # Entry point (port 8000)
│   └── requirements.txt        # Python dependencies
│
├── hub/                        # Local hub controller
│   ├── api/                    # REST endpoints
│   │   └── controllers.py      # Device control API
│   ├── mqtt/                   # MQTT client
│   │   └── client.py           # Message handler
│   ├── services/               # Hub services
│   ├── device_data/            # Local storage
│   │   ├── *.json              # Device state logs
│   │   ├── frames/             # Camera images
│   │   └── videos/             # Recordings
│   ├── main.py                 # Entry point (port 8010)
│   └── requirements.txt
│
├── devices/                    # IoT device simulators
│   ├── light/                  # Smart light
│   │   ├── smart_light.py      # MQTT client
│   │   └── .env                # Device config
│   ├── camera/                 # Camera device
│   │   └── camera.py           # Video capture
│   ├── thermostat/             # Smart thermostat
│   │   └── thermostat.py       # Temp control
│   ├── lock/                   # Smart lock
│   │   └── lock.py             # Lock control
│   └── socket/                 # Smart plug
│       └── socket_device.py    # Power monitoring
│
├── listener/                   # MQTT-to-Backend bridge
│   ├── main.py                 # MQTT subscriber
│   └── requirements.txt
│
├── web/                        # Primary Next.js frontend
│   ├── src/
│   │   ├── pages/              # Next.js pages
│   │   │   ├── authentication/ # Login/Register
│   │   │   ├── dashboard/      # Main dashboard
│   │   │   ├── devices/        # Device management
│   │   │   └── homes/          # Home management
│   │   ├── components/         # React components
│   │   ├── api/                # API client (Axios)
│   │   ├── contexts/           # Auth context
│   │   └── shared/             # Shared UI components
│   ├── package.json
│   └── next.config.mjs
│
├── Ecohive-webapp/             # Alternative Next.js frontend
│   ├── app/                    # Next.js 15 app router
│   ├── tailwind.config.js
│   └── package.json
│
├── app/                        # Flutter mobile app
│   ├── lib/
│   │   ├── pages/              # Flutter screens
│   │   ├── scopedModel/        # State management
│   │   ├── Api/                # HTTP service
│   │   └── Socket/             # WebSocket service
│   ├── pubspec.yaml            # Flutter dependencies
│   └── android/ios/            # Platform configs
│
├── env/                        # Environment configs
├── requirements.txt            # Root Python deps
├── package.json                # Root Node.js deps
└── README.md                   # This file
```

## Prerequisites

### Required Software

- **Python**: 3.8+ (for backend, hub, devices, listener)
- **Node.js**: 18+ and npm/yarn (for web frontend)
- **Flutter**: 3.6+ and Dart SDK (for mobile app)
- **MongoDB**: MongoDB Atlas account or local instance
- **Redis**: Redis server (local or cloud)
- **MQTT Broker**: Mosquitto or any MQTT broker

### Optional Tools

- **ngrok**: For exposing local services to the internet
- **Docker**: For containerized deployment
- **Git**: For version control

## Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd nextgen
```

### 2. Install Backend Dependencies

```bash
cd backend
pip install -r requirements.txt
cd ..
```

### 3. Install Hub Dependencies

```bash
cd hub
pip install -r requirements.txt
cd ..
```

### 4. Install Listener Dependencies

```bash
cd listener
pip install -r requirements.txt
cd ..
```

### 5. Install Device Dependencies

Each device has its own dependencies:

```bash
cd devices/light
pip install -r requirements.txt
cd ../camera
pip install -r requirements.txt
cd ../thermostat
pip install -r requirements.txt
# Repeat for other devices
cd ../..
```

### 6. Install Web Frontend Dependencies

```bash
cd web
yarn install
# or: npm install
cd ..
```

### 7. Install Ecohive-webapp Dependencies (Optional)

```bash
cd Ecohive-webapp
npm install
cd ..
```

### 8. Install Mobile App Dependencies

```bash
cd app
flutter pub get
cd ..
```

## Configuration

### Backend Configuration

Create `/backend/.env`:

```env
# MongoDB
MONGODB_URI=mongodb+srv://<username>:<password>@<cluster>.mongodb.net/?retryWrites=true
DATABASE_NAME=nextdb

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
JWT_SECRET=your_secret_key_here
JWT_ALGORITHM=HS256

# Email (Optional)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASSWORD=your_app_password
```

### Hub Configuration

Create `/hub/.env`:

```env
HUB_ID=hub_001
MQTT_BROKER=localhost
MQTT_PORT=1883
BACKEND_URL=http://localhost:8000
```

### Device Configuration

Create `.env` in each device directory (e.g., `/devices/light/.env`):

```env
DEVICE_ID=light_001
DEVICE_NAME=Living Room Light
MQTT_BROKER=localhost
MQTT_PORT=1883
HUB_ID=hub_001
```

### Listener Configuration

Create `/listener/.env`:

```env
MQTT_BROKER=localhost
MQTT_PORT=1883
BACKEND_URL=http://localhost:8000
# Or with ngrok:
# BACKEND_URL=https://your-ngrok-url.ngrok.io
```

### Web Frontend Configuration

Create `/web/.env.local`:

```env
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_WS_URL=ws://localhost:8000/ws
NEXT_PUBLIC_STRIPE_PUBLIC_KEY=your_stripe_key
NEXT_PUBLIC_GOOGLE_CLIENT_ID=your_google_client_id
NEXT_PUBLIC_RECAPTCHA_SITE_KEY=your_recaptcha_key
```

### Mobile App Configuration

Update `/app/lib/Api/api_service.dart`:

```dart
static const String baseUrl = 'http://your-ip-address:8000';
```

Update `/app/lib/Socket/socket_service.dart`:

```dart
static const String wsUrl = 'ws://your-ip-address:8000/ws';
```

## Running the Application

### 1. Start Redis Server

```bash
redis-server
```

### 2. Start MQTT Broker

```bash
mosquitto
# Or with config:
mosquitto -c /path/to/mosquitto.conf
```

### 3. Start Backend Server

```bash
cd backend
python main.py
```

Backend will run on `http://localhost:8000`

### 4. Start Hub Service

```bash
cd hub
python main.py
```

Hub will run on `http://0.0.0.0:8010`

### 5. Start Listener Service

```bash
cd listener
python main.py
```

### 6. Start Device Simulators

Start each device in the background:

```bash
# Smart Light
cd devices/light
nohup python smart_light.py > output.log 2>&1 &

# Camera
cd ../camera
nohup python camera.py > output.log 2>&1 &

# Thermostat
cd ../thermostat
nohup python thermostat.py > output.log 2>&1 &

# Lock
cd ../lock
nohup python lock.py > output.log 2>&1 &

# Socket
cd ../socket
nohup python socket_device.py > output.log 2>&1 &
```

### 7. Start Web Frontend

```bash
cd web
yarn dev
# or: npm run dev
```

Web app will run on `http://localhost:3000`

### 8. Start Mobile App (Optional)

```bash
cd app
flutter run
```

Select your target device (Android emulator, iOS simulator, or physical device)

## API Documentation

### Authentication Endpoints

#### POST `/auth/register-manager`
Register a new home manager/owner.

**Request:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "secure_password",
  "role": "manager"
}
```

**Response:**
```json
{
  "message": "User registered successfully",
  "user_id": "user_123"
}
```

#### POST `/auth/login`
Login user and receive JWT token.

**Request:**
```json
{
  "email": "john@example.com",
  "password": "secure_password"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "user_123",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "manager"
  }
}
```

### Home Management Endpoints

#### POST `/management/add-home`
Create a new home.

**Request:**
```json
{
  "name": "My Home",
  "address": "123 Main St",
  "hub_id": "hub_001",
  "manager_id": "user_123"
}
```

#### POST `/management/homes`
Get all homes for a user.

**Request:**
```json
{
  "user_id": "user_123"
}
```

#### POST `/management/invite-dweller`
Invite a dweller/guest to a home.

**Request:**
```json
{
  "home_id": "home_456",
  "dweller_email": "guest@example.com"
}
```

### Device Control Endpoints

#### POST `/device/register-device`
Register a new device to a hub.

**Request:**
```json
{
  "device_id": "light_001",
  "device_name": "Living Room Light",
  "device_type": "light",
  "hub_id": "hub_001",
  "home_id": "home_456"
}
```

#### POST `/device/set-device`
Send command to a device.

**Request:**
```json
{
  "device_id": "light_001",
  "command": "turn_on",
  "parameters": {
    "brightness": 80,
    "rgb": [255, 255, 255]
  }
}
```

#### POST `/device/get-device`
Get current device state.

**Request:**
```json
{
  "device_id": "light_001"
}
```

**Response:**
```json
{
  "device_id": "light_001",
  "name": "Living Room Light",
  "type": "light",
  "state": {
    "is_on": true,
    "brightness": 80,
    "rgb": [255, 255, 255],
    "power_consumption": 12.5
  }
}
```

### WebSocket Connection

#### WS `/ws`
Connect to real-time updates.

**Client Message:**
```json
{
  "user_id": "user_123"
}
```

**Server Messages:**
```json
{
  "type": "device_update",
  "device_id": "light_001",
  "state": {
    "is_on": false,
    "brightness": 0
  }
}
```

## Features

### Core Features

- **Multi-user Access Control**
  - Manager (owner) role with full permissions
  - Dweller (guest) role with limited access
  - Invitation-based home sharing
  - Per-home user management

- **Real-time Device Control**
  - Instant command execution (<1s latency)
  - WebSocket-based state updates
  - MQTT protocol for device communication
  - Offline device detection

- **Supported Device Types**
  - **Smart Lights**: On/Off, RGB color, brightness control
  - **Thermostats**: Temperature control, fan speed, heating/cooling modes
  - **Cameras**: Live feed, frame capture, video recording, night vision
  - **Smart Locks**: Lock/unlock control, status monitoring
  - **Smart Plugs**: Power on/off, energy consumption tracking

- **Energy Monitoring**
  - Real-time power consumption per device
  - Historical usage data and analytics
  - Hourly/daily/monthly aggregation
  - Energy cost estimation

- **Media Management**
  - Camera frame capture and storage
  - Video recording with motion detection
  - Local storage with cloud backup option
  - Frame-by-frame playback

- **Cross-platform Support**
  - Responsive web application (desktop & mobile)
  - Native mobile apps (Android & iOS)
  - Hub management dashboard
  - API for third-party integrations

### Advanced Features

- **Social Authentication**: Google, Facebook, LinkedIn OAuth
- **Payment Integration**: Stripe for premium features
- **Security**: reCAPTCHA bot protection, JWT tokens, password hashing
- **AI Integration**: Cohere LLM for text generation, Whisper for speech-to-text
- **Room/Zone Management**: Organize devices by rooms
- **Notification System**: Real-time alerts for device events
- **Device Scheduling**: Automated device control based on time/conditions

## Development

### Running Tests

```bash
# Backend tests
cd backend
pytest

# Frontend tests
cd web
yarn test

# Mobile tests
cd app
flutter test
```

### Building for Production

#### Backend
```bash
cd backend
# Deploy with Gunicorn or containerize with Docker
gunicorn main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker
```

#### Web Frontend
```bash
cd web
yarn build
yarn start
```

#### Mobile App
```bash
cd app
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Code Style

- **Python**: Follow PEP 8 guidelines
- **TypeScript/JavaScript**: ESLint configuration in web projects
- **Dart**: Follow Flutter style guide

### Project Conventions

- Use snake_case for Python variables and functions
- Use camelCase for JavaScript/TypeScript
- Use PascalCase for React components
- Commit messages should be descriptive and follow conventional commits

## Deployment

### Docker Deployment (Recommended)

Create `docker-compose.yml` in the project root:

```yaml
version: '3.8'

services:
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

  mosquitto:
    image: eclipse-mosquitto
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ./mosquitto.conf:/mosquitto/config/mosquitto.conf

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - MONGODB_URI=${MONGODB_URI}
      - REDIS_HOST=redis
    depends_on:
      - redis
      - mosquitto

  hub:
    build: ./hub
    ports:
      - "8010:8010"
    environment:
      - MQTT_BROKER=mosquitto
    depends_on:
      - mosquitto

  web:
    build: ./web
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://backend:8000
```

Run with:
```bash
docker-compose up -d
```

## Troubleshooting

### Common Issues

1. **MQTT Connection Failed**
   - Ensure MQTT broker is running on the correct port
   - Check firewall settings
   - Verify broker address in `.env` files

2. **WebSocket Connection Refused**
   - Check backend is running on port 8000
   - Verify CORS settings in backend
   - Check WebSocket URL in frontend config

3. **MongoDB Connection Error**
   - Verify MongoDB URI in backend `.env`
   - Check network connectivity to MongoDB Atlas
   - Ensure database user has proper permissions

4. **Device Not Responding**
   - Check device is connected to MQTT broker
   - Verify device_id matches in hub and device config
   - Check MQTT topic subscription

5. **Frontend Build Errors**
   - Clear node_modules and reinstall: `rm -rf node_modules && npm install`
   - Check Node.js version compatibility
   - Verify all environment variables are set

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -m 'Add new feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Submit a pull request

## License

This project was developed as part of a software engineering course.

## Support

For issues, questions, or contributions, please contact the development team or open an issue in the repository.

---

**Built with ❤️ for the Smart Home Future**
