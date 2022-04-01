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
                  "start": "T11:00Z"
                }
              ],
              "weekday": 1
            },
            {
              "weekday": 2,
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T15:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ]
            },
            {
              "weekday": 3,
              "times": [
                {
                  "start": "T11:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ]
            },
            {
              "weekday": 4,
              "times": [
                {
                  "start": "T11:00Z"
                },
                {
                  "start": "T19:00Z"
                }
              ]
            },
            {
              "weekday": 5,
              "times": [
                {
                  "start": "T15:00Z"
                }
              ]
            },
            {
              "weekday": 6,
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T19:00Z"
                }
              ]
            },
            {
              "weekday": 7,
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T19:00Z"
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
                  "start": "T19:00Z"
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T15:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "start": "T11:00Z"
                }
              ],
              "weekday": 3
            },
            {
              "times": [
                {
                  "start": "T19:00Z"
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T11:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ],
              "weekday": 5
            },
            {
              "times": [
                {
                  "start": "T11:00Z"
                },
                {
                  "start": "T19:00Z"
                }
              ],
              "weekday": 6
            },
            {
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T11:00Z"
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
                  "start": "T02:00Z"
                },
                {
                  "start": "T19:00Z"
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "start": "T11:00Z"
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "start": "T15:00Z"
                }
              ],
              "weekday": 3
            },
            {
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "start": "T11:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ],
              "weekday": 5
            },
            {
              "times": [
                {
                  "start": "T15:00Z"
                }
              ],
              "weekday": 6
            },
            {
              "times": [
                {
                  "start": "T11:00Z"
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
                  "start": "T02:00Z"
                },
                {
                  "start": "T11:00Z"
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T15:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ],
              "weekday": 3
            },
            {
              "times": [
                {
                  "start": "T11:00Z"
                },
                {
                  "start": "T23:30Z"
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "start": "T15:00Z"
                },
                {
                  "start": "T19:00Z"
                }
              ],
              "weekday": 5
            },
            {
              "times": [
                {
                  "start": "T02:00Z"
                },
                {
                  "start": "T15:00Z"
                }
              ],
              "weekday": 6
            },
            {
              "times": [
                {
                  "start": "T19:00Z"
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
                  "start": "T23:30Z"
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "start": "T15:00Z"
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
                  "start": "T15:00Z"
                }
              ],
              "weekday": 1
            },
            {
              "times": [
                {
                  "start": "T19:00Z"
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
                  "start": "T19:00Z"
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "start": "T15:00Z"
                }
              ],
              "weekday": 4
            },
            {
              "times": [
                {
                  "start": "T00:15Z"
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
                  "start": "T00:15Z"
                }
              ],
              "weekday": 2
            },
            {
              "times": [
                {
                  "start": "T23:30Z"
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
