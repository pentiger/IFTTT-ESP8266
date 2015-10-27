projectID    = "5784"
ACTUATOR1    = "LED1"
ACTUATOR2    = "LED2"
ACTUATOR3    = "LED3"
ACTUATOR4    = "LED4"
ACTUATOR5    = "LED5"
apiKey           = "xxxxxx"
deviceUUID       = "xxxxxxxxx"

serverIP   = "104.155.7.31" -- mqtt.devicehub.net IP
mqttport   = 1883           -- MQTT port (default 1883)
userID     = "xxxxxxx"             -- username for authentication if required
userPWD    = "xxxxxxx"             -- user password if needed for security
clientID   = "ESP8266#1"         -- Device ID
mqtt_state = 0              -- State control

wifiName = "xxxxxxxx"
wifiPass = "xxxxxxxx"

wifi.setmode(wifi.STATION)
wifi.sta.config(wifiName, wifiPass)
wifi.sta.connect()

LED1_pin = 2
LED2_pin = 1
LED3_pin = 4
LED4_pin = 8
LED5_pin = 7


gpio.mode(LED1_pin, gpio.OUTPUT)
gpio.write(LED1_pin, gpio.LOW) 

gpio.mode(LED2_pin, gpio.OUTPUT)
gpio.write(LED2_pin, gpio.LOW) 

gpio.mode(LED3_pin, gpio.OUTPUT)
gpio.write(LED3_pin, gpio.LOW) 

gpio.mode(LED4_pin, gpio.OUTPUT)
gpio.write(LED4_pin, gpio.LOW) 

gpio.mode(LED5_pin, gpio.OUTPUT)
gpio.write(LED5_pin, gpio.LOW) 

function setLED1(state)
  if state == 1 then 
    gpio.write(LED1_pin, gpio.HIGH)  
  else
    gpio.write(LED1_pin, gpio.LOW)  
  end
end

function setLED2(state)
  if state == 1 then 
    gpio.write(LED2_pin, gpio.HIGH)  
  else
    gpio.write(LED2_pin, gpio.LOW)  
  end
end

function setLED3(state)
  if state == 1 then 
    gpio.write(LED3_pin, gpio.HIGH)  
  else
    gpio.write(LED3_pin, gpio.LOW)  
  end
end

function setLED4(state)
  if state == 1 then 
    gpio.write(LED4_pin, gpio.HIGH)  
  else
    gpio.write(LED4_pin, gpio.LOW)  
  end
end

function setLED5(state)
  if state == 1 then 
    gpio.write(LED5_pin, gpio.HIGH)  
  else
    gpio.write(LED5_pin, gpio.LOW)  
  end
end



function mqtt_do()     
     if mqtt_state < 5 then
          mqtt_state = wifi.sta.status() --State: Waiting for wifi

     elseif mqtt_state == 5 then
          m = mqtt.Client(clientID, 120, userID, userPWD)
          mqtt_state = 10 -- State: initialised but not connected
          m:on("message",
          function(conn, topic, data)
               if data ~= nil then
                  -- print("get: "..data)
                  local pack = cjson.decode(data)
                  if pack.state then
                  
                    print(pack.state)
                    if (pack.state == 0 or pack.state == "0")  then
                      setLED1(0)    
                    elseif (pack.state == 1 or pack.state == "1") then
                      setLED1(1)
                   
                    end
                    
                  end
               end
          end)
     elseif mqtt_state == 10 then
          m:connect( serverIP , mqttport, 0, 
          function(conn)
               print("Connected to MQTT:" .. serverIP .. ":" .. mqttport .." as " .. clientID )
               m:subscribe("/a/"..apiKey.."/p/"..projectID.."/d/"..deviceUUID.."/actuator/"..ACTUATOR1.."/state",0, 
               function(conn)
                    print("subscribed!")
               end)
          end)
          mqtt_state = 20
      end
end

tmr.alarm(0, 600, 1, function() mqtt_do() end) -- convert 10000 to dynamic variable
