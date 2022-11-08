import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.numerator,
    required this.denominator,
    required this.neumeratorTitle,
    required this.denominatorTitle,
    required this.cardTitle,
  });

  final double numerator;
  final double denominator;
  final String neumeratorTitle;
  final String denominatorTitle;
  final String cardTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
      child: Card(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: SizedBox(
            height: double.maxFinite,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    cardTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: (numerator == 0 || denominator == 0)
                            ? CircularProgressIndicator(
                                value: 1,
                                color: Colors.grey.shade400,
                                strokeWidth: 16,
                              )
                            : Transform.rotate(
                                angle: (numerator / denominator) * 100,
                                child: CircularProgressIndicator(
                                  value: numerator / denominator,
                                  strokeWidth: 16,
                                  backgroundColor: Colors.grey.shade400,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    SizedBox(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$neumeratorTitle :$numerator",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "$denominatorTitle :$denominator",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
