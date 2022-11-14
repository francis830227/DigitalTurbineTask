# DigitalTurbineTask


1. Why I created this app in one single branch? 
I think the tasks in this app are relatively simple, the conflict between files are controllable at this scale.

2. The page of lists of offers is not smooth when scrolling. 
It's because I didn't handle images cache and prefetching, the cells will fetch image when they appear. If this app is in production, I will use a 3rd party library like SDWebImage(for Obj-c) or KingFisher(for Swift) to deal with images, or even create custom images cache by my own.

3. The helper functions are all static functions.
Since they are dealing with simple tasks, I think it's appropriate to create them statically in current scale. Once they have more complex tasks to do, like async tasks, I will create them as instances, so that it can bring more testability and more control of life cycle.

4. Unfortunately, I still don't match the signature from the header and the signature created by me. But since I can get the results, I decided to show 'signature is incorrect' on the top of the result page.

Thank you!

- 15.11.2022 update: import 'SDWebImage' with SwiftPackageManager
