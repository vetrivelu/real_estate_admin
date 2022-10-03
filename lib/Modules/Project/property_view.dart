import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PropertyView extends StatelessWidget {
  const PropertyView({Key? key, this.property}) : super(key: key);

  final Property? property;

  @override
  Widget build(BuildContext context) {
    PageController? pageViewController;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      floatingActionButton: ButtonBar(
        children: [
          SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(onPressed: () {}, child: Text("Add"))),
          SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.redAccent.shade700)),
                  onPressed: () {},
                  child: Text("Sell"))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.maxFinite,
                child: Card(
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          property?.title ?? "TITLE",
                          style: getText(context).headline2!,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 300,
                          width: 500,
                          child: Image.network(
                            'https://image.shutterstock.com/image-illustration/3d-illustration-image-modern-house-260nw-1753919153.jpg',
                            scale: 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            width: double.maxFinite,
                            height: 350,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 50),
                                  child: PageView(
                                    controller: pageViewController ??=
                                        PageController(initialPage: 0),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Image.network(
                                        'https://picsum.photos/seed/142/600',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Image.network(
                                        'https://picsum.photos/seed/718/600',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Image.network(
                                        'https://picsum.photos/seed/368/600',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 1),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 10),
                                    child: SmoothPageIndicator(
                                      controller: pageViewController ??=
                                          PageController(initialPage: 0),
                                      count: 3,
                                      axisDirection: Axis.horizontal,
                                      onDotClicked: (i) {
                                        pageViewController!.animateToPage(
                                          i,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      },
                                      effect: ExpandingDotsEffect(
                                        expansionFactor: 2,
                                        spacing: 8,
                                        radius: 16,
                                        dotWidth: 16,
                                        dotHeight: 16,
                                        activeDotColor: Colors.blue,
                                        dotColor: Color(0xFF9E9E9E),
                                        paintStyle: PaintingStyle.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Plot Number',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        Text(
                                          '230912',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Survey Number',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        Text(
                                          '765467898',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'DCRP Number',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        Text(
                                          '450',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'District',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        Text(
                                          'Thoothukudi',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Mapilaiurini',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        Text(
                                          '230912',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Property Amount',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_outlined,
                                              size: 20,
                                              color: Colors.red.shade700,
                                            ),
                                            Text(
                                              '20 Lks',
                                              style: TextStyle(
                                                  color: Colors.red.shade700,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.\nLorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,\nwhen an unknown printer took a galley of type and scrambled\nit to make a type specimen book.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Features",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.keyboard_double_arrow_right_sharp,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  'Lorem ipsum dolor sit amet',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.keyboard_double_arrow_right_sharp,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  'Lorem ipsum dolor sit amet',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.keyboard_double_arrow_right_sharp,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  'Lorem ipsum dolor sit amet',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.keyboard_double_arrow_right_sharp,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  'Lorem ipsum dolor sit amet',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Table(
              children: const [
                TableRow(children: [
                  Text("Description"),
                  Text("Description"),
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
