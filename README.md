Save21
======
What is it?
-----------

Save21 is a simple demonstration of an electronic coupon/rebate app running natively on iOS 7.

The idea of electronic coupon originates from existing apps such as Groupon and Checkout51. It relieves the retailer from having to apply the discount at the cash register and lets the product maker to effectively deliver rebates to each customer through the app. The user is able to view and select various offers provided by the product makers, go out and buy the products on rebate from retailers. After purchases are being completed, the user is required to take pictures of the receipts, and send these pictures as the proof of purchases through Save21 to the company running the app. The company verifies the validity of the proofs, credits users of the amounts claimed, and sends out cheques to users who accumulated a substantial amount in their account.



This Demo
------------------
This demo is fully functional feature-wise with mock offers. It freely lets any user to sign up for an account, login to an existing account, and also reclaim the forgotten password through email. Their user information is saved on a Cloud based server. The list of offers including the top banners are fetched from my own web server. Any uploaded photos from the user can be viewed or extracted from my web server for manual verification. 
In the future, a server-side management software will be made to handle the verification.


Technical Details
-------------
The app demonstrates the requirements of a typical iOS app: a native iOS application built in xCode, a web service API that feeds and fetches data from the app to web server, a back-end SQL database for storing flexible contents, and the use of a commercial Backend Service provider such as Parse for managing secure user info. The web API is written in a RESTful manner using PHP and HTTP methods (e.g., GET, PUT, POST, or DELETE).


Testing Environment
------------
This demo is aimed at any iPhone with retina display, running on iOS 7+ 
The project can be opened and compiled using xCode 5.

Known bugs
------------
Although the program is capable of detecting an active internet connection and notify the user, it is not real time and may not work well if the user has an unstable internet connection.


Licensing
---------
Copyright (c) 2013 Feiyang Chen
  
Permission is hereby granted to any person obtaining a copy of this software to view its source code compile and run. 


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Contacts
--------
Feiyang Chen
  
feiyangca@yahoo.ca
  
Waterloo, Ontario, Canada
