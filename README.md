# [AsSearchBox] Search in database without coding 
A simple component to facilitate the search/filter in any TDataset ( Table or Query ) using Filter property . 
  
![](https://1.bp.blogspot.com/-5ORXrtBUFpw/XDgqM3tLDOI/AAAAAAAAAgM/lcuOsCpYop4iJPKZXbH5JqsUQxB35aEmgCLcBGAs/s1600/AsSearchBoxPreview.gif)



![](https://3.bp.blogspot.com/-RdrPG-ChYpY/XDgvxIQJMLI/AAAAAAAAAgk/nAz6ZqpoBNIkiRVP5v1uIpZkhG8-S8X4wCLcBGAs/s1600/howtouse.gif)

# Features 
- **Easy to use.**
- **Coloring by case.**
- **Enable/Disable SearchItem/Field.**
- **Enable/Disable Search.**
- **ADD SearchItem dynamically.**
 
 For example :
  
```
  AsSearchBox1.AddSearchItem('Company' , 'Company Search', loAND, roEqualTo ,'Unisco' , True, True  ); 
```
or 
```
  AsSearchBox1.AddSearchItem('City'); 
```

- **Enable/Disable  CaseSensitive.**
- **Navigate dataset with VK_UP/Vk_DOWN**
- **Custom Input value**
- **Logical Operators ("and"/"or") between SearchItems.**
- **Relational Operators.**


   - **roContains ==>**  (FieldName like '%value%').
   - **roEqualTo ==>**  (FieldName = Value). 
   - **roNotEqualTo ==>**  (FieldName <> Value).
   - **roLessThan ==>** (FieldName < Value).
   - **roLessThanOrEqualTo ==>** (FieldName <= Value).
   - **roGreaterThan ==>** (FieldName ">" Value).
   - **roGreaterThanOrEqualTo ==>** (FieldName >= Value).
   - **roStartWith ==>** (FieldName like '%value').
   - **roEndsWith ==>** (FieldName like 'value%').
      

# Setup
You can watch the video on [Youtube](https://www.youtube.com/watch?v=LElkT1-9Qzc). 
## How to install :

1- Copy files in safe folder

2- Open `AsSearchBoxGroup.groupproj` and select `AsSearchBoxDsgn.dpk`  Right click > Install !
     
then add folder path of `Source` in Library path
        `  Tools>Library ... `


## How to use it :




1- Add `TAsSearchBox` in your form/application .

2- Assign SearchDataSet with your dataset (TTable, TQuery...) , 
  then You'll see a message "Do You want to clear & load ..." 

   a)  Click Yes if you want to automatically load dataset Feilds in SearchItems.
 or  
   b)  Click No and Add manually the fields you want to search in.
  

3- Execute , Good luck ! 

## Thank you 
Please ! Don't forget to  :star:  if you like it 
# 
  
  
![](https://3.bp.blogspot.com/-RdrPG-ChYpY/XDgvxIQJMLI/AAAAAAAAAgk/nAz6ZqpoBNIkiRVP5v1uIpZkhG8-S8X4wCLcBGAs/s1600/howtouse.gif)
