import math
import os

import numpy as np
import scipy.io
import torch


class TrialDataset(torch.utils.data.Dataset):
    """

    """

    def __init__(self, file_path, sequence_length=5, network_type='rnn'):
        """

        """
        self.file_path = file_path
        self.sequence_length = sequence_length
        self.network_type = network_type

        if type(self.file_path) is not list:

            mat_file = scipy.io.loadmat(self.file_path)

            #self.x = torch.Tensor(self.mat_file['normal_force'])
            self.x = torch.cat([torch.Tensor(mat_file['normal_force'].astype('float32')), torch.Tensor(
                mat_file['tangential_force'].astype('float32'))], dim=1).to(torch.float32)

            self.y = torch.Tensor(mat_file['signal_save'].astype(
                'float32')).squeeze().to(torch.float32)

        else:
            
            self.x = torch.zeros((len(self.file_path),))
            self.y = torch.zeros((len(self.file_path),))

            for (ix, file) in enumerate(self.file_path):

                mat_file = scipy.io.loadmat(file)
                x = torch.cat([torch.Tensor(mat_file['normal_force'].astype('float32')), torch.Tensor(
                    self.mat_file['tangential_force'].astype('float32'))], dim=1).to(torch.float32)

                y = torch.Tensor(mat_file['signal_save'].astype(
                    'float32')).squeeze().to(torch.float32)

                self.x[ix] = x
                self.y[ix] = y


    def __len__(self):
        """

        """
        return self.x.shape[0] - self.sequence_length + 1

    def __getitem__(self, idx):
        """

        """
        x = self.x[idx:idx+self.sequence_length]
        y = self.y[idx+int(math.ceil(self.sequence_length/2))-1]

        sample = x, y

        sample = self.preprocess(sample)
        return sample

    def preprocess(self, sample):
        """

        """
        x, y = sample

        y = ((y + 150) / 300)

        y = y.long()

        if self.network_type == 'mlp':
            x = x.view(-1)
            
        return x, y


class HapticDataset(torch.utils.data.Dataset):
    """

    """

    def __init__(self, data_files, sequence_length=5, network_type='rnn', concat_all = False):
        """

        """
        self.data_files = data_files
        self.sequence_length = sequence_length
        self.network_type = network_type
        self.concat_all = concat_all

    def __len__(self):
        """

        """
        if not self.concat_all:

            return len(self.data_files)

        else:

            return 1

    def __getitem__(self, idx):
        """

        """
        if not self.concat_all:
            
            return TrialDataset(self.data_files[idx], sequence_length=self.sequence_length, network_type=self.network_type)

        else:

            return TrialDataset(self.data_files, sequence_length=self.sequence_length, network_type=self.network_type)

def generate_datasets(data_path, train_test_split=0.8, sequence_length=5, network_type='rnn', concat_all = False):
    """

    """
    data_files = os.listdir(data_path)
    data_files = [os.path.join(data_path, data_file)
                  for data_file in data_files]
    number_of_files = len(data_files)
    random_data_files = np.random.permutation(data_files)
    train_files = random_data_files[:int(train_test_split*number_of_files)]
    test_files = random_data_files[int(train_test_split*number_of_files):]

    train_dataset = HapticDataset(
        train_files, sequence_length=sequence_length, network_type=network_type, concat_all=concat_all)
    test_dataset = HapticDataset(
        test_files, sequence_length=sequence_length, network_type=network_type, concat_all=concat_all)

    return train_dataset, test_dataset
    test_dataset = HapticDataset(
        test_files, sequence_length=sequence_length, network_type=network_type)

    return train_dataset, test_dataset


if __name__ == '__main__':

    data_path = '/home/vaydingul20/Documents/RML/Haptics_Modelling/data/'
    train_dataset, test_dataset = generate_datasets(data_path)

    train_dataset_loader = torch.utils.data.DataLoader(
        train_dataset, batch_size=None, shuffle=False)
    print(len(train_dataset_loader))

    for train_trial in train_dataset_loader:

        train_trial_loader = torch.utils.data.DataLoader(
            train_trial, batch_size=2, shuffle=False)

        for (x, y) in train_trial_loader:
            print(x.shape)
            print(y.shape)
            break
        break
