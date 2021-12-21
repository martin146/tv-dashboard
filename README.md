# A1 TV Dashboard

![TV Dashboard](leanback.png)

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br />
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.<br />
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.<br />
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br />
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.


# Service Discovery
When the TV Dashboard is launched, the application is automatically registered to Zeroconf/Avahi service discovery system. Conversely, when the application is closed, the service is unregistered. The service is registered as *TV Dashboard* on port *58000* with the type *_http._tcp*.

## Service Registration format

```
 [POST] http://zeroconf:15051/a1/xploretv/v1/zeroconf
```

```json {cmd=node .line-numbers}
{
   "name":"TV Dashboard",
   "replaceWildcards":true,
   "serviceProtocol":"any",
   "service":{
      "type":"_http._tcp",
      "port":58000,
      "txtRecord":{
         "version":"1.0",
         "provider":"A1 Telekom Austria",
         "product":"Xplore TV-Dashboard"
         "path":"/"
      }
   }
}
```

## Service Deregistration

```
[POST/DELETE] http://zeroconf:15051/a1/xploretv/v1/zeroconf/TV Dashboard
```

## Service Response

```
[GET] http://zeroconf:15051/a1/xploretv/v1/zeroconf
```

```json
[
    {...},
    {
        "name":"TV Dashboard at raspberrypi",
        "hostName":"raspberrypi.local.",
        "domainName":"local",
        "addresses":{
        "ipv4":[
            "127.0.0.1"
        ],
        "ipv6":[]
        },
        "service":{
            "type":"_http._tcp.local.",
            "port":58000,
            "txtRecord":{
                "version":"1.0",
                "provider":"A1 Telekom Austria",
                "product":"Xplore TV-Dashboard"
                "path":"/"
            }
        }
    },
    {...}
]
```

# File Server Deployment

The folder *script* contains automatic installation scripts for Raspberry Pi and OpenWrt devices. Launching the file *install.sh* as the root user *(sudo install.sh)* automatically installs all dependencies to the system and copies files necessary for the TV dashboard to appropriate folders. Notably, the script applies only to *Debian-based* systems. Finally, the TV Dashboard can be accessed on address *http://{localhost/device_ip}/>:58000*.<br />

The installation on OpenWrt devices requires additional prerequisites. Before the actual installation, the LXC container named *tvdasboard* must be present in the system. Then the installation process follows the same steps. Emitting the *install-owrt.sh* command available in *scripts* folder, all dependencies are installed to the system. Finally, the TV Dashboard can be accessed on address *http://tvdashboard:58000*.

# Kiosk Mode Installation

TBD
