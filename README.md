# Netflix-Metadata-Demo

A demo app which fetches and displays Metadata of a netflix video based on the video Id or dynamically fetches it based on the video which is loaded in web view.

Note that the webview mode only works on an iPad since Netflix only allows app for iPhones for playing videos. For the best experience use a real iPad instead of simulator since play of DRM Fairplay videos (all of Netflix's content) crashes Webkit on iPad simulator. This means switching from one video to another is not possible on the simulator and the modes have to be switched to Direct Fetch and switched again to Webview for it to function again.

Cookie has been hardcoded for demo purpose which can be obtained from any laptop browser by using the inspect command when logging in to Netflix
