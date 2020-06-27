# Simple video call App
![vido_call](https://user-images.githubusercontent.com/34925145/85638768-12c59400-b687-11ea-8f6d-1348f533e033.jpg)


Main features
  - Authentication using firebase auth (OTP authentication)
  - Firebase Firestore to store users data [phone + UID+ push notification token]
  - Agora to handle video calls .

# Steps to configure the pp
  - Go to agor.io and sign in then create new project , each project has app ID place this id in porject  [utils/agora_config.dart] file.
   ```dart
      static final String appId = "xxxxxxxxxxxxxxxxxxxxxxxxx";

 ```
  - you are free to use my firebase project but if you want to create your own do this :
     - clone this repo to help you push notifications https://github.com/DedSecTeam17/Firebase-Pusher
     - make sure SHA-1 added to firebase  project because  OTP auth requires it
  - ok, then you are good to go.
  
  
# Todo :
 - ios configuration  
# Screens
  

  

![Screenshot_1592911559](https://user-images.githubusercontent.com/34925145/85638913-7cde3900-b687-11ea-932f-cb95ec932edf.png)
![Screenshot_1592911595](https://user-images.githubusercontent.com/34925145/85638914-7ea7fc80-b687-11ea-8cf9-5c46a9c96b4e.png)
![Screenshot_1592911613](https://user-images.githubusercontent.com/34925145/85638916-7f409300-b687-11ea-940e-e884ddee5a6b.png)
![Screenshot_20200623-132802](https://user-images.githubusercontent.com/34925145/85638918-7fd92980-b687-11ea-84c0-1108e6b3d1a2.jpg)
![Screenshot_20200623-132840](https://user-images.githubusercontent.com/34925145/85638921-7fd92980-b687-11ea-9c70-715a659a2896.jpg)






