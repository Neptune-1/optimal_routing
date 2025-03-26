// import 'dart:async';
// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:optimal_routing/utils/prefs.dart';
//
// import '../consts/styles.dart';
// import 'ads.dart';
//
// class Lamps {
//   static showBottomSheet(BuildContext context, StreamController<int> showTip) {
//     showModalBottomSheet(
//         context: context,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(Style.blockM * 0.5)),
//         ),
//         builder: (ctx) {
//           return TipsBottomSheet(showTip: showTip);
//         });
//   }
// }
//
// class TipsBottomSheet extends StatefulWidget {
//   final StreamController<int> showTip;
//
//   const TipsBottomSheet({Key? key, required this.showTip}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => TipsBottomSheetState();
// }
//
// class TipsBottomSheetState extends State<TipsBottomSheet> {
//   static const List<int> costs = [2, 15, 20];
//   static const List<String> texts = ['- Get 1 line', '- Get the answer', '- To next level'];
//
//   getTip(int number, BuildContext context) {
//     int lampNum = Prefs.getInt('lamps') ?? 1000000;
//     if (lampNum >= costs[number]) {
//       Prefs.setInt('lamps', lampNum - costs[number]);
//       Navigator.pop(context);
//       widget.showTip.add(number);
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Style.block * 20,
//       height: Style.blockH * 8,
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.background,
//         borderRadius: BorderRadius.circular(Style.blockM * 0.5),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: Style.blockM, vertical: Style.blockM * 0.5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.lightbulb,
//                   size: Style.blockM * 1.1,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 SizedBox(
//                   width: Style.blockM * 0.3,
//                 ),
//                 Text((Prefs.getInt("lamps") ?? 0).toString(),
//                     style: GoogleFonts.josefinSans(
//                         fontSize: Style.blockM * 1,
//                         fontWeight: FontWeight.w800,
//                         color: Theme.of(context).colorScheme.primary))
//               ],
//             ),
//             Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: List.generate(
//                     costs.length,
//                     (index) => Padding(
//                           padding: EdgeInsets.all(Style.blockM * 0.5),
//                           child: GestureDetector(
//                             behavior: HitTestBehavior.translucent,
//                             onTap: () => getTip(index, context),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text("${costs[index]}x ",
//                                     style: GoogleFonts.josefinSans(
//                                         fontSize: Style.blockM * 1,
//                                         fontWeight: FontWeight.w800,
//                                         color: Theme.of(context).colorScheme.primary)),
//                                 Icon(
//                                   Icons.lightbulb,
//                                   size: Style.blockM * 1.1,
//                                   color: (Prefs.getInt("lamps") ?? 0) >= costs[index]
//                                       ? Theme.of(context).colorScheme.secondary
//                                       : Theme.of(context).colorScheme.primary,
//                                 ),
//                                 SizedBox(
//                                   width: Style.blockM * 0.3,
//                                 ),
//                                 Text(texts[index],
//                                     style: GoogleFonts.josefinSans(
//                                         fontSize: Style.blockM * 1,
//                                         fontWeight: FontWeight.w800,
//                                         color: Theme.of(context).colorScheme.primary))
//                               ],
//                             ),
//                           ),
//                         ))),
//             ElevatedButton(
//               style: ButtonStyle(
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(Style.blockM * 0.2),
//                   )),
//                   minimumSize: MaterialStateProperty.all(Size.zero),
//                   padding: MaterialStateProperty.all(EdgeInsets.zero),
//                   backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
//                   overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
//                   elevation: MaterialStateProperty.all(0)),
//               onPressed: () => Ads.showPreAdDialog(
//                   context,
//                   () => setState(() {
//                         Prefs.setInt("lamps", (Prefs.getInt("lamps") ?? 0) + 2);
//                         Navigator.pop(context);
//                       })),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     vertical: Style.blockM * 0.5, horizontal: 1.5 * Style.blockM),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text("Get 2x",
//                         style: GoogleFonts.josefinSans(
//                             fontSize: Style.blockM * 1.4,
//                             fontWeight: FontWeight.w800,
//                             color: Theme.of(context).colorScheme.secondary)),
//                     Icon(
//                       Icons.lightbulb,
//                       size: Style.blockM * 1.1,
//                       color: Theme.of(context).colorScheme.secondary,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
