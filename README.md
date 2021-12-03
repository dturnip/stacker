# stacker

## Contents
* [Prerequisites]()
* [Dependencies]()
* [Installation]()
* [Building and Running on Corona Simulator]()
* [Building and Running on Xcode]()
* [Building and Running on iOS]()
* [Game Mechanics]()
    - [Flow]()
    - [Crates]()
    - [Tricky Stuff]()

A mobile crate stacking game built with Lua and the Corona SDK.

## Prerequisites

- Lua (5.4 recommended)
- Corona SDK

## Dependencies

- [fplua](https://github.com/dturnip/fplua)

## Installation

```sh
git clone https://github.com/dturnip/stacker.git
```

## Building and Running on Corona Simulator

1. Open Corona Simulator
2. Click **"Open Project"**
3. Select the cloned directory

## Building and Running on Xcode

## Building and Running on iOS

## Game Mechanics

### Flow

* Crates travel side to side and drop when they collide to the side of another crate or when the screen is tapped
* Crates are transparrent within the first second of it being instantiated and can't collide with anything
* Colliding crates with spikes result in loss of live(s)
* Crates can be strategically dropped as the next spawning crates are displayed in the top right buffers. When six of these are completed, the crates disappear and the speed is increased

### Crates

* **Regular Crate:** This is the default crate. When it collides with a spike, one live is lost.
* **TNT Crate:** This is darker than the regular crate. When it collides with a spike, all lives are lost.

### Tricky Stuff

* **Vertical Push:** When a phasing crate perfecty overlaps another crate as it becomes fully opaque, the crate will be pushed up vertically
* **Horizontal Push:** When a phasing crate becomes fully opaque into another crate, it will be pushed back a bit in the direction it came from
