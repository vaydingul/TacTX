import math
import os

import numpy as np
import scipy.io
import torch
import array

class TrialDataset(torch.utils.data.Dataset):
	"""
	
	"""
	def __init__(self, file_path, sequence_length = 5, transform=None):
		"""
		
		"""
		self.file_path = file_path
		self.sequence_length = sequence_length


		self.mat_file = scipy.io.loadmat(self.file_path)

		self.y = torch.Tensor(self.mat_file['signal']).squeeze()
		self.x = torch.Tensor(self.mat_file['normal_force']).squeeze()

		
		self.transform = transform

	def __len__(self):
		"""
		
		"""
		return self.x.shape[0] - self.sequence_length + 1

	def __getitem__(self, idx):
		"""
		
		"""
		x = self.x[idx:idx+self.sequence_length]
		y = self.y[idx+math.ceil(self.sequence_length/2)]
		sample = x, y
		if self.transform:
			sample = self.transform(sample)
		return sample



class HapticDataset(torch.utils.data.Dataset):
	"""
	
	"""
	def __init__(self, data_files, sequence_length = 5):
		"""
		
		"""
		self.data_files = data_files
		self.sequence_length = sequence_length
	


	def __len__(self):
		"""
		
		"""
		return len(self.data_files)

	def __getitem__(self, idx):
		"""
		
		"""
		return TrialDataset(self.data_files[idx], sequence_length=self.sequence_length)
		

def generate_datasets(data_path, train_test_split = 0.8, sequence_length = 5):

	"""
	
	"""
	data_files = os.listdir(data_path)
	data_files = [os.path.join(data_path, data_file) for data_file in data_files]
	number_of_files = len(data_files)
	random_data_files = np.random.permutation(data_files)
	train_files = random_data_files[:int(train_test_split*number_of_files)]
	test_files = random_data_files[int(train_test_split*number_of_files):]
	
	train_dataset = HapticDataset(train_files, sequence_length=sequence_length)
	test_dataset = HapticDataset(test_files, sequence_length=sequence_length)
	
	return train_dataset, test_dataset

if __name__ == '__main__':

	data_path = '/home/vaydingul20/Documents/RML/Haptics_Modelling/data/'
	train_dataset, test_dataset = generate_datasets(data_path)
	
	train_dataset_loader = torch.utils.data.DataLoader(train_dataset, batch_size = None, shuffle=False)
	print(len(train_dataset_loader))

	for train_trial in train_dataset_loader:

		train_trial_loader = torch.utils.data.DataLoader(train_trial, batch_size = 2, shuffle=False)
		
		for (x, y) in train_trial_loader:
			print(x.shape)
			print(y.shape)
			break
		break
