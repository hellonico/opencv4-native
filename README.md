# OpenCV 4 Native Release Workflow

This project builds the OpenCV Java wrapper and Native libraries for Origami.

**Note:** `build.sh` is deprecated. Please use the `Makefile` for all build operations.

## Architecture

The project uses a two-step "Harvest & Deploy" workflow to support multiple architectures (Linux/macOS/Windows, x86/ARM) from a single repo.

1.  **Harvest**: When you build on a specific machine (e.g., macOS ARM64), the resulting native library (`libopencv_java*.dylib`) is copied into `natives/osx_arm64/`.
2.  **Commit**: You commit this binary to the repository. The `natives/` folder acts as the source of truth for all supported architectures.
3.  **Deploy**: The deployment step packages **everything** currently in `natives/` into a single `opencv-native.jar` (and per-arch jars) and uploads them to the Maven repository.

## Commands

### Full Release (Build + Deploy Core & Natives)

Builds the current architecture from source, updates `natives/`, and deploys everything.

```bash
make release
```

### Native-Only Release

If you only want to add a new architecture's binary (or update an existing one) without rebuilding the Java Core:

```bash
make release-natives
```

### Cleaning

- `make clean`: Removes build artifacts (`build/`, `opencv/build`).
- `make deep-clean`: Removes build artifacts and source folders (`opencv/`, `opencv_contrib/`). **Does NOT remove `natives/`**.

## How to Add a New Architecture

1.  Clone this repo on the new machine (e.g., a Raspberry Pi or Windows box).
2.  Run `make release-natives`.
    - This will compile OpenCV for that machine.
    - It will place the shared library in `natives/<os>_<arch>/`.
    - It will upload the updated `opencv-native.jar` to the repo.
3.  **Commit and Push** the new file in `natives/` so others can use it.

## Prerequisites

- CMake
- Java JDK
- Maven (with `settings.xml` configured for `vendredi` repo)
- Ant
- Git
- Build essentials (make, gcc, etc.)