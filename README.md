# Generative iOS

Xcode workspace containing multiple apps to have fun with generative drawings.

## How to use

0. Make sure you have Cocoapods installed `sudo gem install cocoapods`
1. Clone the project
2. Run `pod install`
3. Open the workspace and start the app you want

It can take a great amount of time and memory to generate and draw the figures, I'd recommend the iOS simulator or a recent device. Currently using an iPhone X.

The drawing style will be vastly different depending on the device screen size.

There is an `HQ` button in some apps, when pressing it you'll be generating at a constant 1000x1000 rendering size.

## Rond

Circle splines, varying in count, number of iterations, colors, etc

Inspired by [inconvergent](https://inconvergent.net/generative/sand-spline/)

#### Results

![Circle splines](https://github.com/dvkch/Generative/raw/master/README/rond_1.png)
![Circle splines](https://github.com/dvkch/Generative/raw/master/README/rond_2.png)
![Circle splines](https://github.com/dvkch/Generative/raw/master/README/rond_3.png)

## Grille

Random points, linked as a grid, leaving marks as they move

Inspired by [Inconvergent](https://inconvergent.net/2016/shepherding-random-grids/)

#### Results

![Grid](https://github.com/dvkch/Generative/raw/master/README/grille_1.png)

## License

idk, MIT ?