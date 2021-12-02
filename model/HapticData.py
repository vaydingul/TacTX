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
		
		for data_file in self.data_files:

			self.mat_file = scipy.io.loadmat(os.path.join(self.data_path, data_file))

			self.x.append(self.mat_file['signal'])
			self.y.append(self.mat_file['normal_force'])

		self.transform = transform

	def __len__(self):
		"""
		
		"""
		return len(self.data_files)

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
	print(len(dataset))
	print(dataset[0])