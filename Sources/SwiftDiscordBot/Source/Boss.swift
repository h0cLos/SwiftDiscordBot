import Foundation

var bossJson: Data? {
    let json = """
    {
      "boss": [
        {
          "name": "克價卡",
          "schedule": [
            {
              "week": 0,
              "times": [
                {
                  "time": 1100
                },
                {
                  "time": 2330
                }
              ]
            },
            {
              "week": 1,
              "times": [
                {
                  "time": 200
                },
                {
                  "time": 1500
                },
                {
                  "time": 2330
                }
              ]
            },
            {
              "week": 2,
              "times": [
                {
                  "time": 1100
                },
                {
                  "time": 2330
                }
              ]
            },
            {
              "week": 3,
              "times": [
                {
                  "time": 1900
                }
              ]
            },
            {
              "week": 5,
              "times": [
                {
                  "time": 200
                },
                {
                  "time": 1900
                }
              ]
            },
            {
              "week": 6,
              "times": [
                {
                  "time": 200
                },
                {
                  "time": 1900
                }
              ]
            }
          ]
        },
        {
          "name": "庫屯",
          "schedule": [
            {
              "week": 0,
              "times": [
                {
                  "time": 1900
                }
              ]
            },
            {
              "week": 1,
              "times": [
                {
                  "time": 200
                },
                {
                  "time": 1500
                },
                {
                  "time": 2330
                }
              ]
            },
            {
              "week": 2,
              "times": [
                {
                  "time": 1100
                }
              ]
            },
            {
              "week": 3,
              "times": [
                {
                  "time": 1900
                }
              ]
            },
            {
              "week": 4,
              "times": [
                {
                  "time": 200
                },
                {
                  "time": 1100
                },
                {
                  "time": 2330
                }
              ]
            },
            {
              "week": 5,
              "times": [
                {
                  "time": 1100
                },
                {
                  "time": 1900
                }
              ]
            },
            {
              "week": 6,
              "times": [
                {
                  "time": 200
                },
                {
                  "time": 1100
                }
              ]
            }
          ]
        }
      ]
    }
    """
    
    return json.data(using: .utf8)
}
