import torch
import numpy as np
import os
import scipy.io

class HapticData(torch.utils.data.Dataset):
	"""
	
	"""
	def __init__(self, data_path, transform=None):
		"""
		
		"""
		self.data_path = data_path
		self.data_files = os.listdir(self.data_path)
		self.x = []
		self.y = []
		
		self.file_idx = 0
		self.data_idx = 0


		for data_file in self.data_files:

			self.mat_file = scipy.io.loadmat(os.path.join(self.data_path, data_file))

			self.x.append(torch.Tensor(self.mat_file['signal']))
			self.y.append(torch.Tensor(self.mat_file['normal_force']))

		self.x = torch.vstack((self.x)).squeeze()
		self.y = torch.vstack((self.y)).squeeze()
		self.transform = transform

	def __len__(self):
		"""
		
		"""
		return self.x.shape[0]

	def __getitem__(self, idx):
		"""
		
		"""
		sample = self.x[idx], self.y[idx]
		if self.transform:
			sample = self.transform(sample)
		return sample


if __name__ == '__main__':

	data_path = '/home/vaydingul20/Documents/RML/Haptics_Modelling/data/'
	dataset = HapticData(data_path)
	
	dataloader = torch.utils.data.DataLoader(dataset, batch_size = 100, shuffle=False)

	for i, data in enumerate(dataloader):
		x, y = data
		print(x.shape, y.shape)
		if i == 0:
			break