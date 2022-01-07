import math
import os

import numpy as np
import scipy.io
import torch


class TrialDataset(torch.utils.data.Dataset):
    """

    """

    def __init__(self, file_path, x_data, y_data, sequence_length=5, num_class = 2, network_type='rnn'):
        """

        """
        self.file_path = file_path
        self.sequence_length = sequence_length
        self.num_class = num_class
        self.network_type = network_type

        if type(self.file_path) is not np.ndarray:

            mat_file = scipy.io.loadmat(str(self.file_path))

            
            self.x = torch.cat([torch.Tensor(mat_file[x].astype('float32')) for x in x_data], dim=1).to(torch.float32)

            self.y = torch.Tensor(mat_file[y_data].astype('float32')).to(torch.float32).squeeze()


        else:
            
            self.x = torch.zeros(0,)
            self.y = torch.zeros(0,)

            for (ix, file) in enumerate(self.file_path):

                mat_file = scipy.io.loadmat(file)

                x = torch.cat([torch.Tensor(mat_file[x_].astype('float32')) for x_ in x_data], dim=1).to(torch.float32)

                y = torch.Tensor(mat_file[y_data].astype('float32')).to(torch.float32).squeeze()


                self.x = torch.cat([self.x, x], dim=0)
                self.y = torch.cat([self.y, y], dim=0)

        pass


    def __len__(self):
        """

        """
        return self.y.shape[0] - self.sequence_length + 1

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


        if y != 0:
            y = torch.tensor(1)
        
        #y = (y + 150) / 300
        

        y = y.long()

        if self.network_type == 'mlp':
            x = x.view(-1)
            
        return x, y


class HapticDataset(torch.utils.data.Dataset):
    """

    """

    def __init__(self, data_files, x_data, y_data, sequence_length=5, num_class = 2, network_type='rnn', concat_all = False):
        """

        """
        self.data_files = data_files
        self.x_data = x_data
        self.y_data = y_data
        self.sequence_length = sequence_length
        self.num_class = num_class
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
            
            return TrialDataset(self.data_files[idx], x_data = self.x_data, y_data = self.y_data, sequence_length=self.sequence_length, num_class = self.num_class, network_type=self.network_type)

        else:

            return TrialDataset(self.data_files, x_data = self.x_data, y_data = self.y_data, sequence_length=self.sequence_length, num_class = self.num_class, network_type=self.network_type)

def generate_datasets(data_path, x_data = ["normal_force"], y_data = "signal_save", train_test_split=0.8, sequence_length=5, num_class = 2, network_type='rnn', concat_all = False, seed = 42):
    """

    """
    np.random.seed(seed)
    data_files = os.listdir(data_path)
    data_files = [os.path.join(data_path, data_file)
                  for data_file in data_files]
    number_of_files = len(data_files)
    random_data_files = np.random.permutation(data_files)
    train_files = random_data_files[:int(train_test_split*number_of_files)]
    test_files = random_data_files[int(train_test_split*number_of_files):]

    train_dataset = HapticDataset(
        train_files, x_data = x_data, y_data = y_data, sequence_length=sequence_length, num_class = num_class, network_type=network_type, concat_all=concat_all)
    test_dataset = HapticDataset(
        test_files, x_data = x_data, y_data = y_data, sequence_length=sequence_length, num_class = num_class, network_type=network_type, concat_all=concat_all)

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
