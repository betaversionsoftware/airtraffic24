db.traffic.aggregate([ 
{ 
  $group: { 
   _id: { 
     icao: "$icao", 
     callsign: "$callsign", 
     lat: "$lat", 
     lng: "$lng", 
     altitude: "$altitude", 
     speed: "$speed", 
     track: "$track" 
   }, 
   count: { 
     $sum: 1 
   } 
  } 
} 
])
