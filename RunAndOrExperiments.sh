export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 20; td = 1; penult = 75; dropout = 0.9; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -l nodes=1:ppn=8
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 30; td = 1; penult = 75; dropout = 0.9; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -l nodes=1:ppn=8
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 0.9; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -l nodes=1:ppn=8
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 2; penult = 75; dropout = 0.9; tot = 1; name='ta'; relu = 0; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -l nodes=1:ppn=8
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -l nodes=1:ppn=8
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 0.9; tot = 1; name='ta'; relu = 0; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -l nodes=1:ppn=8

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 36; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 44; td = 1; penult = 75; dropout = 0.96; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout);" ; qsub -v MATLABCMD quant/run.sh -q john

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 45; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 45; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 1);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 1);" ; qsub -v MATLABCMD quant/run.sh -q john

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 30; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0001; dim = 55; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 1);" ; qsub -v MATLABCMD quant/run.sh -q john

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 50; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.003; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 30; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='ta'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='taf2'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='taf2'; relu = 1; TrainModel(''\, 2\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='taf2'; relu = 1; TrainModel(''\, 3\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='taf2'; relu = 1; TrainModel(''\, 4\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.001; dim = 45; td = 1; penult = 75; dropout = 1; tot = 0; name='taf2'; relu = 1; TrainModel(''\, 5\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh 

export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='taf2'; relu = 1; TrainModel(''\, 1\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='taf2'; relu = 1; TrainModel(''\, 2\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='taf2'; relu = 1; TrainModel(''\, 3\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='taf2'; relu = 1; TrainModel(''\, 4\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john
export MATLABCMD="cd quant; dataflag = 'and-or-deep'; lambda = 0.0003; dim = 40; td = 1; penult = 75; dropout = 1; tot = 1; name='taf2'; relu = 1; TrainModel(''\, 5\, @AndOr\, name\, dataflag\, dim\, penult\, td\, lambda\, tot\, relu\, dropout\, 32);" ; qsub -v MATLABCMD quant/run.sh -q john


==> quant/ta-d40-pen75-top1-tot1-relu1-l0.0003-dropout1/stat_log <==

