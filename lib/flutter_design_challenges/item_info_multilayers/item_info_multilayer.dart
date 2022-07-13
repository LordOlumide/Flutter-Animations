import 'package:flutter/material.dart';

class InfoMultilayerItem extends StatelessWidget {
  const InfoMultilayerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => navigateToInfo(context),
          child: Hero(
            tag: "HeroImage",
            child: Image.asset(
              'assets/images/parallax.jpeg',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

void navigateToInfo(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: ((context, animation, secondaryAnimation) {
        return ItemsMultilayerInfo(animation: animation);
      }),
      // transitionsBuilder: ((context, animation, secondaryAnimation, child) {
      //   return const ItemsMultilayerInfo();
      // }),
    ),
  );
}

class ItemsMultilayerInfo extends StatefulWidget {
  ItemsMultilayerInfo({
    Key? key,
    required this.animation,
  }) : super(key: key);

  Animation<double> animation;

  @override
  State<ItemsMultilayerInfo> createState() => _ItemsMultilayerInfoState();
}

class _ItemsMultilayerInfoState extends State<ItemsMultilayerInfo> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation;

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? 200 : 250,
            child: Hero(
              tag: "HeroImage",
              child: Image.asset(
                'assets/images/parallax.jpeg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ),
        InfoCardsStack(
          animation: animation,
          onExpanded: (value) {
            setState(() {
              isExpanded = value;
            });
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(top: isExpanded ? 25 : 50),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
      ],
    ));
  }
}

class InfoCardsStack extends StatefulWidget {
  InfoCardsStack({
    Key? key,
    required this.animation,
    required this.onExpanded,
  }) : super(key: key);

  final Animation<double> animation;
  Function(bool isExpanded) onExpanded;

  @override
  State<InfoCardsStack> createState() => _InfoCardsStackState();
}

class _InfoCardsStackState extends State<InfoCardsStack> {
  int? activeIndex;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: List.generate(3, (index) {
        return Positioned.fill(
          top: 120,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(
                -widget.animation.value - 0.5 * index,
                widget.animation.value + 0.5 * index,
              ),
              end: const Offset(0, 0),
            ).animate(widget.animation),
            child: InfoCard(
              isActive: index == activeIndex,
              color: colors[index],
              acitveIndex: activeIndex,
              index: index,
              onIndexUpdate: (index) {
                setState(() {
                  activeIndex = activeIndex == index
                      ? (index - 1) >= 0
                          ? index - 1
                          : null
                      : index;
                  if (activeIndex == null) {
                    widget.onExpanded(false);
                  } else {
                    widget.onExpanded(true);
                  }
                });
              },
            ),
          ),
        );
      }),
    );
  }
}

List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
];

class InfoCard extends StatefulWidget {
  InfoCard({
    Key? key,
    required this.isActive,
    required this.color,
    required this.index,
    required this.acitveIndex,
    required this.onIndexUpdate,
  }) : super(key: key);

  bool isActive;
  Color color;
  int index;
  int? acitveIndex;
  Function(int index) onIndexUpdate;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  late Offset positionOffset;

  updatePositionOffset() {
    if (widget.acitveIndex == null) {
      positionOffset = Offset(0, 0.1 * (widget.index + 1));
    } else {
      positionOffset = Offset(
        0,
        widget.index == widget.acitveIndex
            ? 0.1 * widget.index
            : widget.index > widget.acitveIndex!
                ? 1.0 - 0.1 * (3 - widget.index)
                : 0.1 * widget.index,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatePositionOffset();
    //caclulate position offset based on index at initial state
    // if (widget.acitveIndex == null) {
    //   positionOffset = Offset(0, 0.1 * widget.index);
    // } else {
    //   positionOffset = Offset(
    //     widget.index == widget.acitveIndex
    //         ? 0
    //         : widget.index > widget.acitveIndex!
    //             ? 40.0 * (3 - widget.index)
    //             : 0,
    //     widget.index == widget.acitveIndex
    //         ? 0
    //         : widget.index > widget.acitveIndex!
    //             ? 40.0 * (3 - widget.index)
    //             : 0,
    //   );
    // }
  }

  @override
  void didUpdateWidget(covariant InfoCard oldWidget) {
    // TODO: implement didUpdateWidget
    // TODO: implement didChangeDependencies
    if (oldWidget.acitveIndex != widget.acitveIndex) {
      updatePositionOffset();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        // updatePositionOffset();
        widget.onIndexUpdate(widget.index);
        // });
      },
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: positionOffset,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(60),
            ),
          ),
          child: Text(
            "${widget.index}",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline5!.fontSize!,
            ),
          ),
        ),
      ),
    );
  }
}