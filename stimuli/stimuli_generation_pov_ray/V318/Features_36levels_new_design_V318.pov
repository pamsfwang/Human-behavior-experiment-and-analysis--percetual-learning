
#version 3.7;
 // load in pre-defined scene elements
#include "colors.inc" // pre-defined colors      
#include "textures.inc" // pre-defined textures   
#include "shapes.inc"  // pre-defined shapes    
#include "shapes3.inc"  // pre-defined shapes 
 
global_settings { 
assumed_gamma 1}


#declare color_gray = <0.8,0.78,0.8>;      
#declare color_red = <0.45,0.43,0.45>;  

#declare feature = 3;

#declare viewpoint = <0,0,0>;
//original: 0,0,0
//viewpoint2: 0,5,0
//viewpoint3: 0,-5,0
//object parameters  

//feature01

#if (feature = 1)
#declare Index = array[70][3]
{{1,0,0},
 {2,0,0},
 {3,0,0},
 {4,0,0},
 {5,0,0},
 {6,0,0},
 {7,0,0},
 {8,0,0},
 {9,0,0},
 {10,0,0},
 {11,0,0},
 {12,0,0},
 {13,0,0},
 {14,0,0},
 {15,0,0},
 {16,0,0},
 {17,0,0},
 {18,0,0},
 {19,0,0},
 {20,0,0},
 {21,0,0},
 {22,0,0},
 {23,0,0},
 {24,0,0},
 {25,0,0},
 {26,0,0},
 {27,0,0},
 {28,0,0},
 {29,0,0},
 {30,0,0},
 {31,0,0},
 {32,0,0},
 {33,0,0},
 {34,0,0},
 {35,0,0},
 {36,0,0},
 {37,0,0},
 {38,0,0},
 {39,0,0},
 {40,0,0},
 {41,0,0},
 {42,0,0},
 {43,0,0},
 {44,0,0},
 {45,0,0},
 {46,0,0},
 {47,0,0},
 {48,0,0},
 {49,0,0},
 {50,0,0},
 {51,0,0},
 {52,0,0},
 {53,0,0},
 {54,0,0},
 {55,0,0},
 {56,0,0},
 {57,0,0},
 {58,0,0},
 {59,0,0},
 {60,0,0},
 {61,0,0},
 {62,0,0},
 {63,0,0},
 {64,0,0},
 {65,0,0},
 {66,0,0},
 {67,0,0},
 {68,0,0},
 {69,0,0},
 {70,0,0} 
 };
#end
      
//feature02

#if (feature=2) 
#declare Index = array[70][3]
{{0,1,0},
 {0,2,0},
 {0,3,0},
 {0,4,0},
 {0,5,0},
 {0,6,0},
 {0,7,0},
 {0,8,0},
 {0,9,0},
 {0,10,0},
 {0,11,0},
 {0,12,0},
 {0,13,0},
 {0,14,0},
 {0,15,0},
 {0,16,0},
 {0,17,0},
 {0,18,0},
 {0,19,0},
 {0,20,0},
 {0,21,0},
 {0,22,0},
 {0,23,0},
 {0,24,0},
 {0,25,0},
 {0,26,0},
 {0,27,0},
 {0,28,0},
 {0,29,0},
 {0,30,0},
 {0,31,0},
 {0,32,0},
 {0,33,0},
 {0,34,0},
 {0,35,0},
 {0,36,0},
 {0,37,0},
 {0,38,0},
 {0,39,0},
 {0,40,0},
 {0,41,0},
 {0,42,0},
 {0,43,0},
 {0,44,0},
 {0,45,0},
 {0,46,0},
 {0,47,0},
 {0,48,0},
 {0,49,0},
 {0,50,0},
 {0,51,0},
 {0,52,0},
 {0,53,0},
 {0,54,0},
 {0,55,0},
 {0,56,0},
 {0,57,0},
 {0,58,0},
 {0,59,0},
 {0,60,0},
 {0,61,0},
 {0,62,0},
 {0,63,0},
 {0,64,0},
 {0,65,0},
 {0,66,0},
 {0,67,0},
 {0,68,0},
 {0,69,0},
 {0,70,0} 
 };
#end
 
//feautre03
#if (feature =3)
#declare Index = array[70][3]
{{0,0,1},
 {0,0,2},
 {0,0,3},
 {0,0,4},
 {0,0,5},
 {0,0,6},
 {0,0,7},
 {0,0,8},
 {0,0,9},
 {0,0,10},
 {0,0,11},
 {0,0,12},
 {0,0,13},
 {0,0,14},
 {0,0,15},
 {0,0,16},
 {0,0,17},
 {0,0,18},
 {0,0,19},
 {0,0,20},
 {0,0,21},
 {0,0,22},
 {0,0,23},
 {0,0,24},
 {0,0,25},
 {0,0,26},
 {0,0,27},
 {0,0,28},
 {0,0,29},
 {0,0,30},
 {0,0,31},
 {0,0,32},
 {0,0,33},
 {0,0,34},
 {0,0,35},
 {0,0,36},
 {0,0,37},
 {0,0,38},
 {0,0,39},
 {0,0,40},
 {0,0,41},
 {0,0,42},
 {0,0,43},
 {0,0,44},
 {0,0,45},
 {0,0,46},
 {0,0,47},
 {0,0,48},
 {0,0,49},
 {0,0,50},
 {0,0,51},
 {0,0,52},
 {0,0,53},
 {0,0,54},
 {0,0,55},
 {0,0,56},
 {0,0,57},
 {0,0,58},
 {0,0,59},
 {0,0,60},
 {0,0,61},
 {0,0,62},
 {0,0,63},
 {0,0,64},
 {0,0,65},
 {0,0,66},
 {0,0,67},
 {0,0,68},
 {0,0,69},
 {0,0,70}
 };    
#end


//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////      
#declare body_square_param_l = <0.7,0,0.7>;
#declare body_square_param_r = <-0.8,1.1,-0.8>;

//Feature01
#declare Bottemp1 = Index[clock][0]*0.017;
#declare Bottemp2 = Index[clock][0]*0.014;
#declare Bottemp3 = Index[clock][0]*0.0165;          

   
 
#declare protrusion01_square_param_l = <0,-Bottemp1,0>; 
#declare protrusion01_square_param_r = <0.05+Bottemp2,0.2,0.2>;

#declare protrusion02_square_param_l = <0,-Bottemp2,0>;
#declare protrusion02_square_param_r = <0.3,0.25,0.32>; 

#declare protrusion03_square_param_l = <-0.1,-0.05,-Bottemp2>;
#declare protrusion03_square_param_r = <0.15+Bottemp3,0.28,0.23>;       

//Feature02
#declare Bottemp4 = Index[clock][1]*0.011;
#declare Bottemp5 = Index[clock][1]*0.016;
#declare Bottemp6 = Index[clock][1]*0.018;
 
#declare protrusion04_square_param_l = <-Bottemp4,0,-0.1>; 
#declare protrusion04_square_param_r = <0.25,0.35,+Bottemp4>;    

#declare protrusion05_square_param_l = <-0.02,-Bottemp5,-0.02>;
#declare protrusion05_square_param_r = <0.3,0.15,0.3>; 

#declare protrusion06_square_param_l = <0,-Bottemp6,0>;
#declare protrusion06_square_param_r = <0.2,0.2,0.2+Bottemp6>;  



//Feature03    
#declare top1 = Index[clock][2]*0.012;
#declare top2 = Index[clock][2]*0.0145;
#declare top3 = Index[clock][2]*0.0145;


#declare top1_square_param_l=<-0.25,-top1,-0.05>;
#declare top1_square_param_r=<+top1,0.2,0.2>;

#declare top2_square_param_l = <-0.2,-top1,-0.3>;
#declare top2_square_param_r = <0.28,0.15,+top2>;


#declare top3_square_param_l = <-top1,-0.25,-0.1>;//-0.25
#declare top3_square_param_r = <0.28,+top3,0.25>;  

                                     
////////////////////////////////////////////////////////////////// 
//Set up the envrironment                                          
background { color rgb <1, 1, 1> }
camera {
    location <0, 2, 2.3> //0,2.4,2.3
    look_at  <0, 0.5, 0>
  } 
  
light_source { <0, 150, 160> color White}    

/////////////////////////////////////////////////////////////////
//Generate features         
#declare body =
intersection{
  box {body_square_param_l,body_square_param_r    
      texture { pigment{ color rgb color_gray}} 
              } // end of texture   
  box {body_square_param_l, body_square_param_r    
      texture{ pigment{ color rgb color_gray} finish{ambient 0.3 diffuse 0.4}} 
        rotate<5,-35,5>}       
        };

/////////////////////////////////////////////////////////////////        
#declare bottom_protrusion01 =
 intersection{
  box {protrusion01_square_param_l, protrusion01_square_param_r rotate<0,0,0>} // end of texture   
  box {protrusion01_square_param_l, protrusion01_square_param_r rotate<-10,-10,-14>} 
 texture { pigment{ color rgb color_red}} // end of texture 
         };
                                               
#declare bottom_protrusion02 =  
intersection{
  box {protrusion02_square_param_l,  protrusion02_square_param_r  rotate<0,0,0>} 
  box {protrusion02_square_param_l,  protrusion02_square_param_r rotate<-10,-10,-10>}
         texture { pigment{ color rgb color_red}}
         } ;

#declare bottom_protrusion03 = 
intersection{
  box {protrusion03_square_param_l,  protrusion03_square_param_r  rotate<0,0,0>} 
  box {protrusion03_square_param_l,  protrusion03_square_param_r rotate<20,20,10>}
         texture { pigment{ color rgb color_red}}
         } ;      
         
/////////////////////////////////////////////////////////////////        
#declare bottom_protrusion04 =
 intersection{
  box {protrusion04_square_param_l, protrusion04_square_param_r rotate<0,0,0>} // end of texture   
  box {protrusion04_square_param_l, protrusion04_square_param_r rotate<-14,-11,-14>} 
 texture { pigment{ color rgb color_red}} // end of texture 
         };
                                               
#declare bottom_protrusion05 =  
intersection{
  box {protrusion05_square_param_l,  protrusion05_square_param_r  rotate<0,0,0>} 
  box {protrusion05_square_param_l,  protrusion05_square_param_r rotate<-10,-10,-10>}
         texture { pigment{ color rgb color_red}}
         } ;

#declare bottom_protrusion06 = 
intersection{
  box {protrusion06_square_param_l,  protrusion06_square_param_r  rotate<0,0,0>} 
  box {protrusion06_square_param_l,  protrusion06_square_param_r rotate<-20,-2,-25>}
         texture { pigment{ color rgb color_red}}
         } ;

//////////////////////////////////////////////////////////////////////////////////////
#declare top_protrusion1 =
intersection{
  box {top1_square_param_l, top1_square_param_r rotate<0,0,0>} // end of texture   
  box {top1_square_param_l, top1_square_param_r rotate<-15,-15,-15>} 
 texture { pigment{ color rgb color_red}} // end of texture 
         };
         
#declare top_protrusion2 = 
intersection{
  box {top2_square_param_l, top2_square_param_r rotate<0,0,0>} 
  box {top2_square_param_l, top2_square_param_r rotate<-15,-20,-15>}
         texture { pigment{ color rgb color_red}}
         };
                                                

#declare top_protrusion3 =
intersection{
  box {top3_square_param_l, top3_square_param_r  rotate<0,0,0>} 
  box {top3_square_param_l, top3_square_param_r rotate<-15,-20,-15>}
         texture { pigment{ color rgb color_red}}
         };  


////////////////////////////////////////////////////////


#declare whole_stimuli = union{                                                        
object{body}                             

object{bottom_protrusion01 rotate<30,-25,-20> translate<0.3,0.71,0.5>}    
//object{bottom_protrusion02 rotate<0,-20,20> translate<0.2,0.5,0.4>} 
object{bottom_protrusion03 rotate<5,0,-30> translate<0.15,0.76,0.48>}//left up     

object{bottom_protrusion04 rotate<0,-110,15> translate<-0.24,0.62,0.5>}//right top  -0.12   
//object{bottom_protrusion05 rotate<-25,-60,10> translate<-0.16,0.65,0.4>}//right down            -0.23
object{bottom_protrusion06 rotate<30,-95,10> translate<-0.13,0.65,0.55>}


//object{top_protrusion1 rotate<-50,-63,40> translate<-0.24,1.05,-0.44>}//0.15 
object{top_protrusion2 rotate<90,122,-20> translate<0.25,0.92,0>}   
object{top_protrusion3 rotate<-70,40,0> translate<0.15,1.1,-0.25>}//left
}


//Plot the object  
object{whole_stimuli rotate viewpoint} 
