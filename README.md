# [AsSearchBox] Search in database without coding 
A simple component to facilitate the search/filter in any TDataset ( Table or Query ) using Filter property . 
  

AsSearchBox is Inherited from TEdit 


**How to install :**

1- Copy files in safe folder

2- Open `AsSearchBoxGroup.groupproj` and select `AsSearchBoxDsgn.dpk`  Right click > Install !
     
then add folder path of `Source` in Library path
        `  Tools>Library ... `


**How to use it :**

1- Add `TAsSearchBox` in your form/application .

2- Assign SearchDataSet with your dataset (TTable, TQuery...) , 
  then You'll see a message "Do You want to clear & load ..." 

   a)  Click Yes if you want to automatically load dataset Feilds in SearchItems.
 or  
   b)  Click No and Add manually the fields you want to search in.
  

3- Execute , Good luck ! 
