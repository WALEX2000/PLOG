tree1(
    [
        (-3|_),
        (-1|_),
        (2| 
            [
                (-2|_),
                (-1|_),
                (1|_)
            ]
        )
    ]
).

complexTree(
    [
        (-4|[
                (-1|[
                        (-1|_),
                        (1|_)
                    ]
                ),
                (1|_),
                (2| [
                        (-3|_),
                        (1|_),
                        (2|_)
                    ]
                )
            ]
        ),
        (1| [
                (-1|_),
                (1|_),
                (2|_)
            ]
        ),
        (2|_)
    ]
).

tree5(
    [
        (-3|_),
        (-1|_),
        (2| 
            [
                (-2|_),
                (-1|_),
                (1|_)
            ]
        )
    ]
).

tree8(
    [
        (-1|
            [
                (-1|
                    [
                        (-2| _),
                        (-1| _),
                        (1| _)
                    ]),
                (2| _)
            ]
        ),
        (1| 
            [
                (-3|_),
                (-2|_),
                (-1|_),
                (2|_)
            ]
        )
    ]
).

testTree([
        (-4|_),
        (-2|_),
        (2|[
            (-3|_),
            (4|[
                (-3|_),
                (4|_)
            ]),
            (5|_),
            (6|[
                (-2|_),
                (3|_)
                ])
            ])
        ]).

tree20(
    [
        (-4|
            [
                (-3|_),
                (-2|_),
                (3|_)
            ]
        ),
        (-2|
            [
                (-2|_),
                (-1|_),
                (1|
                    [
                        (-1|
                            [
                                (-1|_),
                                (2|_),
                                (3|_)
                            ]
                        ),
                        (1|_),
                        (2|_)
                    ]
                )
            ]
        ),
        (1|_),
        (3|
            [
                (-1|
                    [
                        (-1|
                            [
                                (-1|_),
                                (1|
                                    [
                                        (-2|_),
                                        (1|_)
                                    ]
                                ),
                                (2|_),
                                (3|_)
                            ]
                        ),
                        (1|_),
                        (2|_)
                    ]
                ),
                (1|_),
                (2|_)
            ]
        )
    ]
).