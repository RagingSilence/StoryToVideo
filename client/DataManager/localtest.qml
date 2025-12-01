// localtest.qml
import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2

//Rectangle {
//    width: 400
//    height: 300
//    color: "#222"

//    property var testData: {
//        return {
//            "storyId": "STORY-LOCAL-001",
//            "title": "本地故事测试",
//            "shots": [
//                { "id": 1, "prompt": "第一幕" },
//                { "id": 2, "prompt": "第二幕" }
//            ]
//        }
//    }

//    Column {
//        anchors.centerIn: parent
//        spacing: 15

//        Button {
//            text: "保存数据到本地"
//            width: 200
//            onClicked: {
//                dataManager.saveData(testData, "story_test.json")
//            }
//        }

//        Button {
//            text: "加载本地数据"
//            width: 200
//            onClicked: {
//                var loaded = dataManager.loadData("story_test.json")
//                console.log("加载后的数据:", JSON.stringify(loaded))
//            }
//        }

//        Button {
//            text: "删除本地数据"
//            width: 200
//            onClicked: {
//                dataManager.clearData("story_test.json")
//            }
//        }
//    }
//}
Rectangle {
    width: 500
    height: 600
    color: "#1e1e1e"

    // -------------------------------
    // 模拟“完整故事结构”
    // -------------------------------
    property var storyData: {
        return {
            "storyId": "STORY-001",
            "title": "消失的城市",
            "description": "一个探险者进入废弃城市，逐渐揭开隐藏的真相。",
            "author": {
                "name": "魏以约",
                "id": "user-001"
            },

            "createTime": "2025-01-12 10:22:00",
            "updateTime": "2025-01-12 10:45:30",

            // -------------------------------
            //  分镜（scenes）
            // -------------------------------
            "scenes": [
                {
                    "sceneId": 1,
                    "title": "进入废墟",
                    "summary": "主人公进入废弃城市的大门，夜色昏暗。",
                    "frames": [
                        {
                            "frameId": "1-1",
                            "prompt": "一个探险者推开残破的铁门，夜色幽深，风吹过废墟。",
                            "aspectRatio": "16:9",
                            "thumbUrl": "http://example.com/thumbs/scene1_frame1.jpg",
                            "finalImageUrl": "http://example.com/images/scene1_frame1.jpg",
                            "isApproved": true
                        },
                        {
                            "frameId": "1-2",
                            "prompt": "城市街道布满尘土，一盏闪烁的路灯仍在亮着。",
                            "aspectRatio": "16:9",
                            "thumbUrl": "http://example.com/thumbs/scene1_frame2.jpg",
                            "finalImageUrl": "http://example.com/images/scene1_frame2.jpg",
                            "isApproved": false
                        }
                    ]
                },
                {
                    "sceneId": 2,
                    "title": "主塔探索",
                    "summary": "主角进入城市中心的主塔，内部灯光忽明忽暗。",
                    "frames": [
                        {
                            "frameId": "2-1",
                            "prompt": "巨大的主塔大厅，破碎的玻璃窗散落一地，光束从裂口打入。",
                            "aspectRatio": "9:16",
                            "thumbUrl": "http://example.com/thumbs/scene2_frame1.jpg",
                            "finalImageUrl": "http://example.com/images/scene2_frame1.jpg",
                            "isApproved": true
                        }
                    ]
                }
            ],

            // -------------------------------
            // 视频导出结果（可选）
            // -------------------------------
            "video": {
                "exported": false,
                "videoUrl": "",
                "thumbnail": ""
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            text: "保存完整故事结构"
            width: 260
            onClicked: {
                console.log("➡ 开始保存 story.json")
                dataManager.saveData(storyData, "story.json")
            }
        }

        Button {
            text: "加载 story.json"
            width: 260
            onClicked: {
                var data = dataManager.loadData("story.json")
                console.log("⬆ 加载的数据:")
                console.log(JSON.stringify(data, null, 2))
            }
        }

        Button {
            text: "删除 story.json"
            width: 260
            onClicked: {
                dataManager.clearData("story.json")
            }
        }
    }
}
