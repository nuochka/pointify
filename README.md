# pointify
**Pointify** is a productivity and self-improvement mobile application that motivates users to achieve their goals by completing tasks. Each completed task earns the user points, helping them visualize their progress and stay motivated.

The core idea is to gamify goal setting: in order to reach their goals, users must consistently complete smaller tasks. The app encourages focus, habit building, and personal development through this structured reward system.

## Technologies
### Frontend (iOS):
- SwiftUI
- Combine
- UserDefaults
- URLSession

### Backend:
- Vapor (Swift)
- PostgreSQL
- JSON APIs

## Getting Started (Development)
**Requirements:**
- Xcode 16+
- Swift 6.0.3+
- Vapor Toolbox 19.1.1+
- PostgreSQL installed locally or on a server


## To run the project:

### 1. Clone the project repository to your local machine:
```bash
git clone https://github.com/nuochka/pointify.git
cd pointify
```

### 2. Open the Xcode project:
Open the `Pointify.xcodeproj` file in Xcode:
```bash
open Pointify.xcodeproj
```
Run the app on a simulator or device.

### 3. Set up and configure the backend server:
Navigate to the backend directory of the project:
```bash
cd PointifyServer/
```

Before running the backend, make sure you configure your **PostgreSQL database** connection settings.

- Open the `.env` file in the backend directory.
- Update the database URL with your own PostgreSQL setup. For example:
  ```env
  DATABASE_URL=postgresql://localhost/pointify
  ```

If you don’t have PostgreSQL installed, you can install it using Homebrew:
```bash
brew install postgresql
```

Start PostgreSQL:
```bash
brew services start postgresql
```

### 4. Run the backend server:
Now you can start the backend server by running:
```bash
vapor run serve
```
This will start the Vapor server locally at `http://localhost:8080` by default.



