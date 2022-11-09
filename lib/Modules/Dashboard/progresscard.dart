import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.numerator,
    required this.denominator,
    required this.neumeratorTitle,
    required this.denominatorTitle,
    required this.cardTitle,
    required this.valueColor,
    required this.backGroundColor,
  });

  final double numerator;
  final double denominator;
  final String neumeratorTitle;
  final String denominatorTitle;
  final String cardTitle;
  final Color valueColor;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        color: backGroundColor,
        child: SizedBox(
          height: double.maxFinite,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  cardTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                    color: valueColor,
                                    value: numerator / denominator,
                                    strokeWidth: 16,
                                    backgroundColor: Colors.grey.shade400,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 64),
                      Expanded(
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(children: [
                              Text(denominator.toString(), style: Theme.of(context).textTheme.headline3),
                              Text(numerator.toString(), style: Theme.of(context).textTheme.headline3),
                            ]),
                            TableRow(children: [
                              Text(neumeratorTitle, style: Theme.of(context).textTheme.bodyLarge),
                              Text(denominatorTitle, style: Theme.of(context).textTheme.bodyLarge),
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
