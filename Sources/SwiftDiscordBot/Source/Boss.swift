import Foundation

var bossJson: Data? {
    let json = """
    {
      "boss": [
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                }
              ],
              "weekday": 1
            },
            {
              "weekday": 2,
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 15,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ]
            },
            {
              "weekday": 3,
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ]
            },
            {
              "weekday": 4,
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                },
                {
                  "hour": 19,
                  "minute": 0
                }
              ]
            },
            {
              "weekday": 5,
              "times": [
                {
                  "hour": 15,
                  "minute": 0
                }
              ]
            },
            {
              "weekday": 6,
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 19,
                  "minute": 0
                }
              ]
            },
            {
              "weekday": 7,
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 19,
                  "minute": 0
                }
              ]
            }
          ],
          "boss": "克價卡"
        },
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 15,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                }
              ],
              "weekday": 3
            },
            {
              "times": [
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 11,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 5
            },
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                },
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 6
            },
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 11,
                  "minute": 0
                }
              ],
              "weekday": 7
            }
          ],
          "boss": "庫屯"
        },
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "hour": 15,
                  "minute": 0
                }
              ],
              "weekday": 3
            },
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 5
            },
            {
              "times": [
                {
                  "hour": 15,
                  "minute": 0
                }
              ],
              "weekday": 6
            },
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                }
              ],
              "weekday": 7
            }
          ],
          "boss": "卡嵐達"
        },
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 11,
                  "minute": 0
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 15,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 3
            },
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                },
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "hour": 15,
                  "minute": 0
                },
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 5
            },
            {
              "times": [
                {
                  "hour": 2,
                  "minute": 0
                },
                {
                  "hour": 15,
                  "minute": 0
                }
              ],
              "weekday": 6
            },
            {
              "times": [
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 7
            }
          ],
          "boss": "羅裴勒"
        },
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "hour": 11,
                  "minute": 0
                }
              ],
              "weekday": 6
            },
            {
              "times": [
                {
                  "hour": 15,
                  "minute": 0
                }
              ],
              "weekday": 7
            }
          ],
          "boss": "奧平"
        },
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 15,
                  "minute": 0
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 3
            }
          ],
          "boss": "貝爾"
        },
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 19,
                  "minute": 0
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "hour": 15,
                  "minute": 0
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "hour": 0,
                  "minute": 15
                }
              ],
              "weekday": 7
            }
          ],
          "boss": "卡莫斯"
        },
        {
          "schedule": [
            {
              "times": [
                {
                  "hour": 0,
                  "minute": 15
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "hour": 23,
                  "minute": 30
                }
              ],
              "weekday": 6
            }
          ],
          "boss": "肯恩特_木拉卡"
        }
      ]
    }
    """
    
    return json.data(using: .utf8)
}
