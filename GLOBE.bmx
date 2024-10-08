Import MaxGui.Drivers '2 be used for the progress bar in the beginning
AppTitle="Protocol Globe"
Graphics 1280,720,0
SeedRnd MilliSecs()
'DELTATIME
Type Delta
  Global DeltaTime:Double
  Global TimeDelay:Long
  Function Start()
    TimeDelay = MilliSecs()
  End Function
  Function time#()
    Return DeltaTime# 'Function only used for debugging purposes
  End Function
  Function Update()
    DeltaTime = (( MilliSecs() - TimeDelay )*0.001 )*60 'Multiply by 60 to emulate 60 frames per second
    TimeDelay = MilliSecs()
  End Function
End Type

Rem 'Currently unused!
'TYPES
Type treegrower
	Field building:Int
	Field built:Int
	Field x:Float
	Field y:Float
EndType 

Type cloudseeder
	Field building:Int
	Field built:Int
	Field x:Float
	Field y:Float	
EndType 

Type hab
	Field building:Int
	Field built:Int
	Field x:Float
	Field y:Float	
EndType 

Type thermalgen
	Field building:Int
	Field built:Int
	Field x:Float
	Field y:Float	
EndType 


'VARIABLES N TYPES
EndRem 'Will fix later!


'PROGRESS BAR
Local window:TGadget=CreateWindow("My Window",640,360,365,100,,WINDOW_TITLEBAR)
Local progbar:TGadget=CreateProgBar(10,10,325,30,window)
CreateLabel "Loading...",10,35,200,25,window 'Create a 'loading' text

'VARIABLES
'Global shake:Float ; shake=0 [Redundant]
Global funds:Float ; funds=175.0
Global water:Float ; water=255 'km³ (Millions)
Global trees:Float ; trees=150 'km² (Millions)
Global planethp:Float ; planethp=50 'Dont get this to 0 or its Game Over, however do get it to 100+, thats how you win ;)
Global count:Int
Global treegrowers:Int ; treegrowers=0
Global tgresearch:Int ; tgresearch=0
Global cloudseeders:Int ; cloudseeders=0
Global csresearch:Int ; csresearch=0
Global hubs:Int ; hubs=0
Global hubresearch:Int ; hubresearch=0
Global tradeports:Int ; tradeports=0 
Global tpresearch:Int ; tpresearch=0
Global typex:Int ; typex=-1 '-1=Null 0-9=Treegrower 10-19=Cloud Seeder 20-29=Hab 30-39=Neo-Thermal Generators
Global isbuilding:Int ; isbuilding=0 '0=Null 1=Tree Grower 2=Cloud Seeder 3=Hab Complex 4=Neo-Thermal Generators|Negative of each will cancel
Global temp:Float ; temp=280 'K
Global pollution:Float ; pollution=10 'µg/m³
Global manhours:Float ; manhours=3600 'Hrs
Global staffpop:Float ; 
Global staffrate:Float ; staffrate=0.00025
Global staffwarn:Int ; staffwarn=0
Global staff:Float ; staff=10
Global actualstaff:Int ; actualstaff=Floor(staff)
Global maxstaff:Int ; maxstaff=25
Global staffpol:Float ; staffpol=1
Global maxstaffpol:Float ; maxstaffpol=staffpol*2
Global tempred:Float
Global tempblu:Float
Global warn:TImage = LoadImage("Media/warn.png")
UpdateProgBar progbar,1/10
Global megawarn:TImage = LoadImage("Media/uhoh.png")
UpdateProgBar progbar,2/10
Global warnsound:TSound = LoadSound("Media/warning.wav")
UpdateProgBar progbar,3/10
Global tgimage:TImage = LoadImage("Media/treegrower.png")
UpdateProgBar progbar,4/10
Global nasa:TImage = LoadImage("Media/NASA.png")
UpdateProgBar progbar,5/10
Global tpimage:TImage = LoadImage("Media/Bankwhat.png",0)
UpdateProgBar progbar,6/10
Global csimage:TImage = LoadImage ("Media/cloudseeder.png")
UpdateProgBar progbar,7/10
Global main:TSound = LoadSound ("Media/main.ogg")
Global mainchannel:TChannel = CueSound(main)
UpdateProgBar progbar,8/10
Global tutmusic:TSound = LoadSound ("Media/tutorial.ogg")
Global tutchannel:TChannel = CueSound(tutmusic)
UpdateProgBar progbar,9/10
Global hubimage:TImage = LoadImage ("Media/house.png",0)
UpdateProgBar progbar,1
MidHandleImage tgimage
MidHandleImage csimage
MidHandleImage nasa
MidHandleImage tpimage
MidHandleImage hubimage
FreeGadget window 
FreeGadget progbar 'Free up the progress bar and window as it has served its purpose

SetColor 255,255,255
DrawText "There is a distant planet in a neighbouring solar system",320,175
DrawText "With a unique eco-system, in which can survive cold and hot up to 325Kelvins",320,200
DrawText "In which its eco-system, has been devastated by pollution",320,225
DrawText "Caused by meteor strikes and now its eco-system is dying",320,250
DrawText "You have been assigned the task to lead a project, named 'Protocol Globe'",320,275
DrawText "To save the planet, you will have to manage resources",320,300
DrawText "and think carefully of your next move.",320,325
DrawText "Will you be able to save the planet?",320,400
DrawText "Press H for tutorial, otherwise press any key to continue...",320,600
Flip
WaitKey()
Global tutorial:Int = GetChar()
FlushKeys
Cls 
If tutorial=104 Then 
DrawImage tgimage,50,50
DrawText "Tree Grower: Simple and easy to make, as in the name, grows trees",100,25
DrawText "Cost: 300 Man-hours  15 Funds  0 Trees  0 Water",100,50
DrawText "Trees reduce pollution although consume water",100,75
DrawImage csimage,75,175
DrawText "Cloud Seeders: By releasing certain chemicals into the air we can create clouds in which cause rain, increasing water supply",150,100
DrawText "Cost: 600 Man-hours  35 Funds  0 Trees  0 Water",150,125
DrawText "Water reduces temperature and provides nutrition for trees, very useful",150,150
DrawImage hubimage,50,300
DrawText "Hab Unit/Complex: Habitation Unit/Complex, a living space for our staff to be in, vital so it doesnt get cramped, increases max staff capacity",100,250
DrawText "Cost: 150 Man-hours  5 Funds  5 Trees  0 Water",100,275
DrawText "If staff goes over the limit, the amount of pollution created by each staff will multiply",100,300
DrawImage tpimage,100,450
DrawText "Trade Port: Very costly however also very profitable, creating this will generate more funds available to use for research and construction",150,350
DrawText "Cost: 600 Man-hours  35 Funds  0 Trees  0 Water",150,375
DrawText "Funds are used in just about everything",150,400
DrawText "[0]  Construct a building",200,500
SetColor 0,255,255
DrawText "[0]  Research building tech (boosts building stat)",200,525
SetColor 255,255,255
DrawText "Press SpaceBar to continue...",550,675
Flip
Repeat 
If Not ChannelPlaying(tutchannel) Then
	tutchannel=CueSound(tutmusic)
	ResumeChannel(tutchannel)
EndIf
Until KeyHit(KEY_SPACE)
EndIf
StopChannel (tutchannel)
StopChannel (tutchannel)
StopChannel (tutchannel)
Delta.Start() 'Initialize DeltaTime
While Not KeyHit(KEY_ESCAPE)
Delta.Update()
manhours=manhours+(staff/150)*Delta.DeltaTime
If planethp>=100 Then endgame(0)
If planethp<=0 Then endgame(1)
If staff<=0 Then endgame(2)

If Not ChannelPlaying(mainchannel) Then
	mainchannel=CueSound(main)
	ResumeChannel(mainchannel)
EndIf

If staffrate>0 Then staffwarn=0
If staffrate<=0 And staffwarn=0 Then 'If staff pop. starts to decrease, warn player
	staffwarn=1
	PlaySound warnsound
EndIf
staffrate=0.0001+((planethp-50)/25000)/(temp/280)
funds=funds+Float(((0.0025)+((0.0075*tradeports)*(tpresearch+1)))*Delta.DeltaTime)
Print staffrate
Rem
If isbuilding=0 Then
	If KeyHit(KEY_1) Then selconst(1)
	If KeyHit(KEY_2) Then selconst(2)
	If KeyHit(KEY_3) Then selconst(3)
	If KeyHit(KEY_4) Then selconst(4)
EndIf
EndRem 'WILL FIX LATER
If KeyHit (KEY_1) And manhours>=300 And funds>=15 Then addbuild(1)
If KeyHit (KEY_2) And manhours>=600 And funds>=35 Then addbuild(2)
If KeyHit (KEY_3) And manhours>=150 And funds>=5 And trees>=5 Then addbuild(3)
If KeyHit (KEY_4) And manhours>=900 And funds>=50 And trees>=20 And water>=25 Then addbuild(4)
If KeyHit (KEY_5) And manhours>=450 And funds>=25 And trees>=25 Then addresearch(1)
If KeyHit (KEY_6) And manhours>=600 And funds>=25 And water>=50 Then addresearch(2)
If KeyHit (KEY_7) And manhours>=300 And funds>=15 Then addresearch(3)
If KeyHit (KEY_8) And manhours>=1200 And funds>=75 Then addresearch(4)

staffpop=staffpop+staffrate*Delta.DeltaTime
Print staffpop
If staffpop>=1 Then
	Repeat
		staffpop=staffpop-1
		staff=staff+1
	Until staffpop<1
EndIf
If staffpop<0 Then
	Repeat
		staffpop=staffpop+1
		staff=staff-1
	Until staffpop>=0
EndIf
actualstaff=Floor(staff)
maxstaffpol=(staff/maxstaff)*staffpol
'maxstaffpol=staffpol*maxstaffpol
tempred=(temp-280)*25
Print tempred
tempblu=(310-temp)*25
Print tempblu
maxstaff=25+(hubs*5*(hubresearch+1))
If tempred>255 Then tempred=255
If tempblu>255 Then tempblu=255
If staff>maxstaff Then
	pollution=pollution+((maxstaffpol*actualstaff)/10000)*Delta.DeltaTime 'Pollution will be multiplied depending on how much more staff there are compared to the maximum
Else
	pollution=pollution+((staffpol*actualstaff)/10000)*Delta.DeltaTime 
EndIf
pollution=pollution-((trees/175000)*Delta.DeltaTime)
trees=trees-((((pollution/7500)/(water^(1/3)+1))-(treegrowers*(0.0005+(tgresearch*0.00025))))*Delta.DeltaTime)
water=water-((trees/75000)-(cloudseeders*(0.0010+(csresearch*0.0005))))*Delta.DeltaTime
planethp=(water/510*50)+(trees/300*50)-(pollution/10)
Print "PlanetHP="+planethp
If temp>325 Then 'Planet becoming too hot is going to be a game ender, Watch out! 
	water=water-0.0075*Delta.DeltaTime
	trees=trees-0.0025*Delta.DeltaTime
EndIf
temp=280+pollution*2.5
temp=temp-(water/100)
If pollution<=0 Then pollution=0
If trees<=0 Then trees=0
If water<=0 Then water=0
If temp<=275 Then temp=275
SetColor 0,127,0
DrawRect 0,0,1280,720
SetColor 255,255,255
'Warning!!!

If pollution>12 Then DrawImage warn,(Len(String(pollution))*8)+136,10
If water<200 Then DrawImage warn,(Len(String(water))*8)+168,30
If trees<150 Then DrawImage warn,(Len(String(trees))*8)+168,40
If temp>305 Then DrawImage warn,(Len(String(temp))*8)+68,50

SetColor 255,255,255
DrawImage nasa,640,360
DrawImage tgimage,250,600
DrawImage csimage,450,600
DrawImage hubimage,700,600
DrawImage tpimage,950,600
DrawText "[1]",200,650
DrawText "[2]",365,650
DrawText "[3]",650,650
DrawText "[4]",850,665
DrawText treegrowers,200,550
DrawText cloudseeders,365,550
DrawText hubs,650,540
DrawText tradeports,850,535
SetColor 0,255,255
DrawText "[5]",300,650
DrawText "[6]",535,650
DrawText "[7]",750,650
DrawText "[8]",1050,665
DrawText tgresearch,300,550
DrawText csresearch,535,550
DrawText hubresearch,750,540
DrawText tpresearch,1050,535
SetColor 0,255,0
DrawText "Funds:"+Int(funds)+"."+Int((funds*10)-(Int(funds)*10))+"$",0,0
SetColor 200,200,200
DrawText "Pollution:"+pollution+" ug/m^3",0,10
If actualstaff>maxstaff Then
	DrawText "Pol. Per Staff:"+maxstaffpol+" ug/m^3 (ten-thousandths)",0,20
Else 
	DrawText "Pol. Per Staff:"+staffpol+" ug/m^3 (ten-thousandths)",0,20
EndIf
SetColor 0,100,255
DrawText "Water:"+water+"km^3 (Millions)",0,30
SetColor 0,255,100
DrawText "Trees:"+trees+"km^2 (Millions)",0,40
SetColor Int(tempred),0,Int(tempblu)
DrawText "Temperature:"+Int(temp)+"."+Int((temp*10)-(Int(temp)*10))+"K",0,50
SetColor 200,150,50
DrawText "Manhours:"+Int(manhours)+"."+Int((manhours*10)-(Int(manhours)*10))+"Hrs",0,60
SetColor 255,255,255
If staff>maxstaff And staffwarn=0 Then 
DrawImage warn,(Len(String(actualstaff))*8)+(Len(String(maxstaff))*8)+112,70
SetColor 255,50,50
EndIf
If staffwarn=1 Then
DrawImage megawarn,(Len(String(actualstaff))*8)+(Len(String(maxstaff))*8)+112,70
SetColor 255,0,0
DrawText "WARNING!!! Your staff population is reducing!",(Len(String(actualstaff))*8)+(Len(String(maxstaff))*8)+128,70
EndIf
DrawText "Staff:"+actualstaff+"/"+maxstaff+" People",0,70 
Flip False
Cls
Wend
End

Function addbuild(buildtype) '1=Tree Grower 2=Cloud Seeder 3=Hab Complex 4=Trading Port
Select buildtype
	Case 1
		manhours=manhours-300
		funds=funds-15
		treegrowers=treegrowers+1
	Case 2
		manhours=manhours-600
		funds=funds-35
		cloudseeders=cloudseeders+1
	Case 3
		manhours=manhours-150
		funds=funds-5
		trees=trees-5
		hubs=hubs+1
	Case 4
		manhours=manhours-900
		funds=funds-50
		trees=trees-20
		water=water-25
		tradeports=tradeports+1
EndSelect
EndFunction

Function addresearch(researchtype)
Select researchtype
	Case 1
		manhours=manhours-450
		funds=funds-25
		trees=trees-25
		tgresearch=tgresearch+1
	Case 2
		manhours=manhours-600
		funds=funds-25
		water=water-50
		csresearch=csresearch+1
	Case 3
		manhours=manhours-300
		funds=funds-15
		hubresearch=hubresearch+1
	Case 4
		manhours=manhours-1200
		funds=funds-75
		tpresearch=tpresearch+1
EndSelect
EndFunction

Function endgame(lose) '0=YOU WON!!!\(^▽^)/  1=YOU LOST!!!(╯°□°）╯︵ ┻━┻   2=YOU LOST AS WELL!!! (because there is no staff to save this planet)              ignore this->1=The planet died because of heat🔥 2=Too much Pollution 3=All staff left°Д°
Cls
Select lose
	Case 0
	SetColor 0,255,0
	DrawText "CONGRATULATIONS!!!!!",540,260
	DrawText "You saved the planet!",540,360
	Case 1
	SetColor 255,0,0
	DrawText "The Planet is destroyed beyond saving!",475,250
	If trees<=25 Then DrawText "There was too little trees! They convert the carbon dioxide in the air to oxygen which can reduce air pollution",100,350
	If water<=50 Then DrawText "There was too little water! Water is essential for life and its used by the trees to live, without it, the planet dries and heats up!", 50,375
	If temp>=325 Then DrawText "The planet was too hot! The planet was so hot it dried and burnt the eco-system, it also caused some of our staff to get heatstrokes!", 50,400
	If pollution>=12 Then DrawText "There was too much air pollution! The air was so polluted it became a hazard to go outside, hence killing trees and harming the planet environment!",25,425
	Case 2
	SetColor 255,0,0
	DrawText "There is no staff left to save the planet!",475,250
	If trees<=50 Then DrawText "There was too little trees! They convert the carbon dioxide in the air to oxygen which can reduce air pollution",100,350
	If water<=100 Then DrawText "There was too little water! Water is essential for life and its used by the trees to live, without it, the planet dries and heats up!", 50,375
	If temp>=315 Then DrawText "The planet was too hot! The planet was so hot it dried and burnt the eco-system, it also caused some of our staff to get heatstrokes!", 50,400
	If pollution>=12 Then DrawText "There was too much air pollution! The air was so polluted it became a hazard to go outside, hence killing trees and harming the planet environment!",25,425
EndSelect
Flip
Local window:TGadget = CreateWindow("Good Game!",640,360,480,200,Null)
CreateLabel("Game Over! Thank you for playing our game!",60,20,320,200,window,LABEL_CENTER)
WaitKey()
End
EndFunction 

Rem
Function selconst(buildingtype)
isbuilding=buildingtype
EndFunction 

Function construct(buildnumber)
buildnumber
If 
	Select 
		Case 
	EndSelect
EndFunction
EndRem 'WILL FIX LATER (and expand! :D)