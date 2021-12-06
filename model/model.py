import torch
import torch.nn as nn
from tqdm import tqdm
from torch import autograd
class SysID(nn.Module):


	def __init__(self, input_size, hidden_size, output_size, num_layers, dropout=0.5):
		super(SysID, self).__init__()
		self.input_size = input_size
		self.hidden_size = hidden_size
		self.output_size = output_size
		self.num_layers = num_layers

		self.rnn = nn.RNN(input_size, hidden_size, num_layers, batch_first=True, dropout=dropout, nonlinearity='relu')
		self.fc = nn.Sequential(
			nn.Linear(hidden_size, int(hidden_size/2)),
			nn.Linear(int(hidden_size/2), int(hidden_size/4)),
			nn.Linear(int(hidden_size/4), output_size),
			nn.Sigmoid()
		)



	def forward(self, x):


		out, self.hidden = self.rnn(x, self.hidden)
		out = self.fc(out[:, -1, :])

		return out


	def init_hidden(self, batch_size, device):
		
		self.hidden = torch.zeros(self.num_layers, batch_size, self.hidden_size).to(device)

	def generate_dummy_input_output(self, batch_size, seq_len):
		return torch.randn(batch_size, seq_len, self.input_size), torch.randn(batch_size, self.output_size)
		

if __name__ == '__main__':

	input_size = 6
	hidden_size = 128
	output_size = 1
	num_layers = 3
	batch_size = 20
	seq_len = 3

	net = SysID(input_size, hidden_size, output_size, num_layers)
	net.train()
		

	criterion = nn.MSELoss()
	optimizer = torch.optim.Adam(net.parameters(), lr=0.001)
	pbar = tqdm(range(1000))

	for _ in pbar:
		
		
		x, y = net.generate_dummy_input_output(batch_size, seq_len)
	
		optimizer.zero_grad()
		output = net(x)
		loss = criterion(output, y)
		loss.backward()
		optimizer.step()

		pbar.set_description(f'Loss: {loss.item():.4f}')		
