import numpy as np

matrix = []
matrix.append(np.array([[0,-1,0],
                        [1,-1,0],
                        [0,0,1]]))

matrix.append(np.array([[-1,1,0],
                        [-1,0,0],
                        [0,0,1]]))

matrix.append(np.array([[-1,0,0],
                        [0,-1,0],
                        [0,0,1]]))

matrix.append(np.array([[0,1,0],
                        [-1,1,0],
                        [0,0,1]]))

matrix.append(np.array([[1,-1,0],
                        [1,0,0],
                        [0,0,1]]))

matrix.append(np.array([[0,-1,0],
                        [-1,0,0],
                        [0,0,1]]))

matrix.append(np.array([[-1,1,0],
                        [0,1,0],
                        [0,0,1]]))

matrix.append(np.array([[1,0,0],
                        [1,-1,0],
                        [0,0,1]]))

matrix.append(np.array([[0,1,0],
                        [1,0,0],
                        [0,0,1]]))

matrix.append(np.array([[1,-1,0],
                        [0,-1,0],
                        [0,0,1]]))

matrix.append(np.array([[-1,0,0],
                        [-1,1,0],
                        [0,0,1]]))

for x in range(len(matrix)):
    for y in range(len(matrix)):
        m = np.matmul(matrix[x], matrix[y])
#        print('{} {} {}\n\n'.format(x,y,m))
        for z in range(len(matrix)):
            if np.array_equiv(matrix[z],m):
                print('{} {} {} {}\n\n'.format(x+2,y+2,z+2,m))
        

       


        
