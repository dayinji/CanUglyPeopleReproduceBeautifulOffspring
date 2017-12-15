# encoding=utf-8
import os
def rename():
	count=0
	path=r'C:\Users\tom\Desktop\sketch_171214b\originImage'
	savepath=r'C:\Users\tom\Desktop\sketch_171214b\originRenameImage'
	filelist=os.listdir(path)
	count = 0
	for files in filelist:
		Olddir=os.path.join(path,files)
		if os.path.isdir(Olddir):
			continue
		filename=os.path.splitext(files)[0]
		Newdir=os.path.join(savepath, "" + str(count) +".jpg")
		os.rename(Olddir,Newdir)
		count+=1
rename()