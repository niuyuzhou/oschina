Open Source China
==========
It is the iPhone app for Open Source China which is one of the biggest open source communities in China.
This app provides users with a wide range of channels such as News, Friends, Search, Tweet and so on.

My work
--------
As a parter, I was mainly involved in development and adaption of several channels such as News, Search and so on. 

Download
--------
- Apple App Store : https://itunes.apple.com/au/app/kai-yuan-zhong-guo/id524298520?mt=8

The introduction of the framework of this project
--------
**1、AFNetwork** --- Third-Party Network Library<br/>
**2、GCDiscreetNotificationView** --- Top pop and it will automatically disappear notification bar<br/>
**3、Thread** --- A background thread object, the process is sent back with pictures move<br/>
**4、SoftwareGroup** --- All software and software packet page index page<br/>
**5、Friends** --- Friends List, including fans and followers<br/>
**6、Search** --- Search Page<br/>
**7、Favorite** --- Collection Page<br/>
**8、MBHUD** --- Loading prompt control<br/>
**9、FTColor** --- Rich text display controls<br/>
**10、EGOImageLoading** --- Asynchronous Image Control<br/>
**11、User** --- Other Personal Profile and login Pages<br/>
**12、Comment** --- Reviews and comments page Page<br/>
**13、AsyncImg** --- Asynchronous image control, always load a list of user Avatar<br/>
**14、Setting** --- Login, logout and about us<br/>
**15、Profile** --- Dynamic page, post a comment and dialogue bubbles<br/>
**16、News** --- List news, quizzes and all types of articles details page<br/>
**17、Tweet** --- Move list, published to move and move Details<br/>
**18、Helper** --- Project assisted category<br/>
**19、TBXML** --- xml parsing, XML string deserialization API returned all<br/>
**20、ASIHttp** --- Another Third-Part network library, responsible for user login, and send with pictures move<br/>
**21、Model** --- All entity objects in this project<br/>
**22、Resource** --- Project Resources<br/>

The following is sub objects of the Model catalogue：
> Model<br>
> ├ Tweet --- the move list units<br>
> ├ News --- Newsletter unit<br>
> ├ Post --- Answers list unit<br>
> ├ Message --- Messages list unit<br>
> ├ Activity --- Dynamic list unit<br>
> ├ Config --- Configuration settings<br>
> ├ SingleNews --- News Details<br>
> ├ SinglePostDetail --- Q&A details<br>
> └ Comment --- Comments list unit<br>
> └ Software --- App Details<br>
> └ Blog --- Blog details<br>
> └ Favorite --- Favorite lists unit<br>
> └ SearchResult --- Search results list unit<br>
> └ Friend --- Friends list unit<br>
> └ SoftwareCatalog --- Software Category list unit<br>
> └ SoftwareUnit --- Software List Unit<br>
> └ BlogUnit --- Blog list unit<br>

The start-up stream of this project
--------
declare a UITabBarController in the start-up of OSAppDelegate then fill<br/>
NewsBase<br/>
PostBase<br/>
TweetBase2<br/>
ProfileBase<br/>
SettingView<br/>
into the 5 UITabItems
