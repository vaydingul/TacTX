import torch
import torch.nn as nn
from tqdm import tqdm

class Network(nn.Module):


	def __init__(self, input_size, hidden_size, output_size, num_layers, dropout=0.5):
		super(Network, self).__init__()
		self.input_size = input_size
		self.hidden_size = hidden_size
		self.output_size = output_size
		self.num_layers = num_layers
		self.rnn = nn.RNN(input_size, hidden_size, num_layers, batch_first=True, dropout=dropout)
		self.fc = nn.Linear(hidden_size, output_size)
		self.h = None
	def forward(self, x):

		if self.h is None:
			self.h = self.init_hidden(20)

		out, self.h = self.rnn(x, self.h)
		out = self.fc(out[:, -1, :])
		return out


	def init_hidden(self, batch_size):
		return torch.zeros(self.num_layers, batch_size, self.hidden_size)
	
	def generate_dummy_input_output(self, batch_size, seq_len):
		return torch.randn(batch_size, seq_len, self.input_size), torch.randn(batch_size, self.output_size)
		

if __name__ == '__main__':

	input_size = 6
	hidden_size = 128
	output_size = 1
	num_layers = 2
	batch_size = 20
	seq_len = 3

	net = Network(input_size, hidden_size, output_size, num_layers)
	net.train()
	
		

	criterion = nn.MSELoss()
	optimizer = torch.optim.Adam(net.parameters(), lr=0.001)




		
	x, y = net.generate_dummy_input_output(batch_size, seq_len)
	optimizer.zero_grad()

	out = net(x)


	loss = criterion(out, y)
	loss.backward()
	optimizer.step()

	x, y = net.generate_dummy_input_output(batch_size, seq_len)
	optimizer.zero_grad()

	out = net(x)


	loss = criterion(out, y)
	loss.backward()
	optimizer.step()

		
