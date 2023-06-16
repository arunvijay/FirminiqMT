# FIRMINIQ - iOS Machine Test - Arun Vijay

The project downloads images from given URLs and update them to a grid. The user can select to download synchronously or asynchronously. Synchronous download will download the images serially one by one starting from the first. Asynchronous download will download all images concurrently.

## Implementation

UICollectionview is used to design the grid, each item of equal size. The collection view size is set to 3/4th of the screen. The download operation is implemented using the OperationQueue. If sync is selected, each image is downloaded serially one by one - maximum concurrent operation set to 1. If async is selected, images are downloaded concurrently - with maximum concurrent operation set to the number of images.


