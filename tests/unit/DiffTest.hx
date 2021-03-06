package tests.unit;

import connect.Diff;
import haxe.Json;


class DiffTest extends haxe.unit.TestCase {
    public function testAdditions() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {y: 'World'},
            d: {},
            c: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testDeletions() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {x: 'Hello'},
            c: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesNoChange() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {x: untyped ['10', 10]}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {x: ['Hello', 'World']}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: {
                    a: {z: 'World'},
                    d: {},
                    c: {}
                }
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: {
                    a: {},
                    d: {z: 'World'},
                    c: {}
                }
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: {
                    a: {},
                    d: {},
                    c: {
                        y: ['Hello', 'World'],
                        z: ['Hi', 'He']
                    }
                }
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArrayAdd() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: [
                    [30],
                    [],
                    []
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArrayDelete() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: [
                    [],
                    [30],
                    []
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
                    [],
                    [],
                    [
                        [1, 20, 30]
                    ]
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArraySimpleChangeAndDelete() {
        final a = {x: [10, 20, 100]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
                    [],
                    [100],
                    [
                        [1, 20, 30]
                    ]
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArrayArrayChange() {
        final a = {x: untyped [10, [20]]};
        final b = {x: untyped [10, [30]]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
                    [],
                    [],
                    [
                        [1, [
                            [],
                            [],
                            [
                                [0, 20, 30]
                            ]
                        ]]
                    ]
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArrayObjectChange() {
        final a = {x: untyped [10, {y: 20}]};
        final b = {x: untyped [10, {y: 30}]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
                    [],
                    [],
                    [
                        [1, {
                            a: {},
                            d: {},
                            c: {
                                y: [20, 30]
                            }
                        }]
                    ]
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testComplexObjects() {
        final first = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final second = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            }
        };
        final diff = new Diff(first, second);
        final expected = {
            a: {},
            d: {},
            c: {
                title: ['Hello', 'Hellooo'],
                stargazers: [
                    ['/users/40'],
                    [],
                    []
                ],
                settings: {
                    a: {},
                    d: {},
                    c: {
                        assignees: [
                            [],
                            [],
                            [
                                [2, 201, 202]
                            ]
                        ]
                    }
                }
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testApplySame() {
        final obj = {x: 'Hello'};
        final diff = new Diff(obj, obj);
        this.assertEquals(Std.string(obj), Std.string(diff.apply(obj)));
    }


    public function testApplyWithAddition() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithDeletion() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithArrayAddition() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithArrayDeletion() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithArrayArrayChange() {
        final a = {x: untyped [10, [20]]};
        final b = {x: untyped [10, [30]]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyWithArrayObjectChange() {
        final a = {x: untyped [10, {y: 20}]};
        final b = {x: untyped [10, {y: 30}]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(b), Std.string(diff.apply(a)));
    }


    public function testApplyComplex() {
        final first = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final second = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            }
        };
        final diff = new Diff(first, second);
        this.assertEquals(Std.string(second), Std.string(diff.apply(first)));
    }


    public function testSwapSame() {
        final obj = {x: 'Hello'};
        final diff = new Diff(obj, obj);
        this.assertEquals(Std.string(obj), Std.string(diff.swap().apply(obj)));
    }


    public function testSwapWithAddition() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithDeletion() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithArrayAddition() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithArrayDeletion() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithArrayArrayChange() {
        final a = {x: untyped [10, [20]]};
        final b = {x: untyped [10, [30]]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapWithArrayObjectChange() {
        final a = {x: untyped [10, {y: 20}]};
        final b = {x: untyped [10, {y: 30}]};
        final diff = new Diff(a, b);
        this.assertEquals(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    public function testSwapComplex() {
        final first = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final second = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            }
        };
        final diff = new Diff(first, second);
        this.assertEquals(Std.string(first), Std.string(diff.swap().apply(second)));
    }


    public function testBuildWithAdditions() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {y: 'World'};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithDeletions() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        final expected = {};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesNoChange() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        final expected = {};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = {x: 10};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        final expected = {x: 'World'};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        final expected = {x: {z: 'World'}};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        final expected = {x: {}};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = {x: {y: 'World', z: 'He'}};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesArrayAdd() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        final expected = {x: [30]};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesArrayDelete() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        final expected = {x: []};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {x: [null, 30]};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesArraySimpleChangeAndDelete() {
        final a = {x: [10, 20, 100]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {x: [null, 30]};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesArrayArrayChange() {
        final a = {x: untyped [10, [20]]};
        final b = {x: untyped [10, [30]]};
        final diff = new Diff(a, b);
        final expected = {x: [null, [30]]};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithChangesArrayObjectChange() {
        final a = {x: untyped [10, {y: 20}]};
        final b = {x: untyped [10, {y: 30}]};
        final diff = new Diff(a, b);
        final expected = {x: [null, {y: 30}]};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithComplexObjects() {
        final first = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final second = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            }
        };
        final diff = new Diff(first, second);
        final expected = {
            title: 'Hellooo',
            stargazers: ['/users/40'],
            settings: {
                assignees: [null, null, 202]
            }
        };
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    public function testBuildWithAddedId() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {id: 'Identifier', y: 'World'};
        this.assertEquals(Json.stringify(expected), Json.stringify(diff.apply({id: 'Identifier'})));
    }


    public function testNoObj() {
        final a = 0;
        final b = {x: 'Hello', y: 'World'};
        try {
            new Diff(a, b);
            this.assertTrue(false);
        } catch (ex: Dynamic) {
            this.assertTrue(true);
        }
    }


    public function testNoObj2() {
        final a = {x: 'Hello'};
        final b = 0;
        try {
            new Diff(a, b);
            this.assertTrue(false);
        } catch (ex: Dynamic) {
            this.assertTrue(true);
        }
    }
}
