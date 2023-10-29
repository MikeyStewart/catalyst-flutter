import 'package:catalyst_flutter/data/principle.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GuidingPrinciples extends StatefulWidget {
  final Function() _openDrawer;

  GuidingPrinciples(this._openDrawer);

  @override
  State<StatefulWidget> createState() {
    return _GuidingPrinciplesState();
  }
}

class _GuidingPrinciplesState extends State<GuidingPrinciples> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guiding Principles'),
        leading: IconButton(
          onPressed: widget._openDrawer,
          icon: Icon(Icons.menu),
        ),
      ),
      body: Stack(children: <Widget>[
        CarouselSlider(
          items: Principle.values
              .map((principle) => Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/principles/${principle.name}.png',
                          width: 200,
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            principle.displayName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Text(
                          principle.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ))
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: false,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            initialPage: 0,
            enlargeFactor: 0.8,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            height: double.maxFinite,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () => _controller.previousPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear),
                  icon: Icon(Icons.arrow_back),
                  iconSize: 48,
                ),
                Spacer(),
                Text('${_current + 1}/${Principle.values.length}'),
                Spacer(),
                IconButton.filledTonal(
                  onPressed: () => _controller.nextPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear),
                  icon: Icon(Icons.arrow_forward),
                  iconSize: 48,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
