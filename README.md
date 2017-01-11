## Tool_Belt

Tool_Belt is the latest contribution to the peer-to-peer sharing economy.  Tool_Belt enables users to share and borrow common household tools with their neighbors.  It is said that the average use of a common household tool is only 30 minutes across a tool's lifetime - most common tools are necessary for specific projects but hardly needed thereafter.  This makes common tools a natural resource to share rather than purchase for specific household projects.

Whether folks need a tool for a unique undertakings such as a grass seed spreader for seeding a new lawn, or common tools as basic as a hammer for assembling a new bedframe Tool_Belt provides users with the option to lend and borrow tools from their neighbors on an as-needed basis.  

# Stack

Tool_Belt is a native iOS mobile application built in Swift 2.3.  

Tool_Belt uses [Backendless](https://www.google.com) of its backend (MBaaS).  This app was originally built with a Rails API for a backend, which was a bit overkill and less than ideal for an agile mobile application.  Backendless provides user security, supports the simply one-to-many relationship between users and tools on their 'ToolBelt' as well as Geolocation services for location-based tool searching.  

Tool_Belt also provides users with the ability to chat directly with each other to make tool-borrowing arrangements via direct personal messages hosted by [Firebase](https://firebase.google.com/).


# Case #1 - Login and searching

Tool_Belt user accounts can be created from scratch and users can also be authenticated via a Facebook login.  Once logged in the user has access to his profile page (lower left tab), his personal messages (lower right) and the map searching feature to search for tools nearby via a simple word search - "drill" or "ladder" for instance.

Here is a demonstration of myself logging in via Facebook and searching for a pressure washer - a typical household tool often needed for single-use projects, such as treating a weathered wooded deck or garage floor.

![alt text](tool1.gif)


