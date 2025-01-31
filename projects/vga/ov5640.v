//https://cdn-learn.adafruit.com/assets/assets/000/118/994/original/OV5640_datasheet.pdf?1677598686
//720p timings
//380e = 03 //set total vertical size high byte
//380f =  F0 //set total vertical size low byte
//(You may need to increase the above for 3-bytes per pixel though; and tweak pixel clock settings...)
//3814 = 31
//3815 = 31
//3808 = 05
//3809 = 00
//380a = 02 //set total vertical size for DVP output high byte
//380b = D0 //set total vertical size for DVP output low byte

//YUV444
//4300 = 20
//501F = 00