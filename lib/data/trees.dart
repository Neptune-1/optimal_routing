import 'tree_9.dart' as trees_9;
import 'tree_10.dart' as trees_10;
import 'trees_2.dart' as trees_2;

List trees = [trees_9.trees.reversed.toList(), trees_10.trees, trees_2.trees, trees_2.trees];

List exampleTree = [
  [
    [0, 0],
    [2, 0],
    [2, 2],
    [0, 2]
  ],
  6,
  [
    [
      [0, 0],
      [0, 1]
    ],
    [
      [0, 1],
      [0, 2]
    ],
    [
      [0, 1],
      [1, 1]
    ],
    [
      [1, 1],
      [2, 1]
    ],
    [
      [2, 0],
      [2, 1]
    ],
    [
      [2, 1],
      [2, 2]
    ]
  ],
  3
];
