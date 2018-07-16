import tensorflow as tf
import numpy

nsamples = 1000

#Data generation, probably a better way to do this
x_data = numpy.floor(2*numpy.random.random([nsamples,2]))-1
y_data = numpy.array(map(lambda x: (x[0] or x[1]) and not (x[0] and x[1]),x_data))
y_data = y_data.reshape([nsamples,1])

test_x_data = numpy.array([[-1,-1],[-1,1],[1,-1],[1,1]])
test_y_data = numpy.array([[-1],[1],[1],[-1]])

#Just a way of choosing data from this set
data_indices = numpy.random.choice(range(len(test_x_data)),nsamples)
x_data = numpy.array(test_x_data[data_indices]) 
y_data = numpy.array(test_y_data[data_indices])

#You can think of most the tensorflow variables as actually being functions that we will call when we want to get their value. 
input_ph = tf.placeholder(tf.float32, shape=[2,1]) #This will be the place the input to the network is inserted
target_ph =  tf.placeholder(tf.float32, shape=[1,1]) #This will be the place the target for the network is insertedd
W1 = tf.Variable(tf.random_uniform([2,2],-1,1)) #First layer weights
b1 = tf.Variable(tf.random_uniform([2,1],-1,1)) # " " biases
W2 = tf.Variable(tf.random_uniform([1,2],-1,1)) #2nd layer
b2 = tf.Variable(tf.random_uniform([1],-1,1))
output = tf.nn.tanh(tf.matmul(W2,tf.nn.tanh(tf.matmul(W1,input_ph)+b1))+b2) #This is the actual construction of the network. When we want to get the output of the network, we will tell tensorflow what to put in the input placeholder, and then we'll run this output function

loss = tf.reduce_sum(tf.square(output - target_ph)) #This is the function we're trying to optimize. The reduce_sum is not really necessary since we only have a single output, just using it to flatten the output.
optimizer = tf.train.AdamOptimizer(0.005) #This is a fancy version of momentum based gradient descent optimization.
train = optimizer.minimize(loss) #This will be how we tell the network to train on an example


# Launch the graph -- tell tensorflow to initialize everything.
init = tf.initialize_all_variables()
sess = tf.Session()
sess.run(init) #first argument to sess.run is function to run, here we're running the initialize function

def test():
    MSE = 0.0
    for i in xrange(len(test_x_data)):
	MSE += sess.run(loss,feed_dict={input_ph: test_x_data[i].reshape([2,1]),target_ph: test_y_data[i].reshape([1,1])}) #test on a test data point. feed_dict is how you pass things in to the placeholders created above
    MSE /= 4
    return MSE

# Fit the function
print "Pre training MSE:", test
for step in xrange(10000):
    sess.run(train,feed_dict={input_ph: x_data[step % nsamples].reshape([2,1]),target_ph: y_data[step % nsamples].reshape([1,1])}) #Run training on an example
    if step % 100 == 0:
	print "On step %i, test MSE %f" %(step,test())

print "Post training MSE:", test()

print "Final weights:"
print(sess.run(W1),sess.run(b1),sess.run(W2),sess.run(b2))
