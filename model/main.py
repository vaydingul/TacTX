import model
import dataset_util
from train import train

from torch import nn
import torch

if __name__ == '__main__':
	
	if torch.cuda.is_available():
		
		device = 'cuda:0'

	else:
		
		device = 'cpu'


	# Load the dataset
	DATA_PATH = '/home/vaydingul20/Documents/RML/Haptics_Modelling/data/'

	# Batch size
	BATCH_SIZE = 32
	INPUT_SIZE = 1
	OUTPUT_SIZE = 1
	NUM_LAYERS = 1
	HIDDEN_SIZE = 128
	SEQUENCE_LENGTH = 13

	train_dataset, test_dataset = dataset_util.generate_datasets(DATA_PATH, sequence_length=SEQUENCE_LENGTH)

	train_dataset_loader = torch.utils.data.DataLoader(train_dataset, batch_size = None, shuffle=True)
	test_dataset_loader = torch.utils.data.DataLoader(test_dataset, batch_size = None, shuffle=True)
	# Import network model
	model = model.SysID(INPUT_SIZE, HIDDEN_SIZE, OUTPUT_SIZE, NUM_LAYERS)

	criterion = nn.MSELoss()
	optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

	
	

	train(model = model, device = device, dataset = train_dataset_loader, criterion = criterion, optimizer = optimizer, batch_size = BATCH_SIZE, epoch = 100) 