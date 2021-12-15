from torch.nn.modules import dropout
import model
import dataset_util
from train import train, evaluate
from torch import nn
import torch
import os
import numpy as np
import time
if __name__ == '__main__':

    if torch.cuda.is_available():

        device = 'cuda:0'

    else:

        device = 'cpu'

    # Load the dataset
    DATA_PATH = '/home/vaydingul20/Documents/RML/Haptics_Modelling/data/asd/'

    # Batch size
    BATCH_SIZE = 10000
    INPUT_SIZE = 1
    OUTPUT_SIZE = 2
    NUM_LAYERS = 4
    HIDDEN_SIZE = 128
    SEQUENCE_LENGTH = 128
    NUM_EPOCHS = 20
    NETWORK_TYPE = 'mlp'
    DROPOUT = 0.
    CONCAT_ALL = False

    train_dataset, test_dataset = dataset_util.generate_datasets(
        data_path=DATA_PATH, sequence_length=SEQUENCE_LENGTH, network_type=NETWORK_TYPE, concat_all=CONCAT_ALL, train_test_split=0.5)

    train_dataset_loader = torch.utils.data.DataLoader(
        train_dataset, batch_size=None, shuffle=False)
    test_dataset_loader = torch.utils.data.DataLoader(
        test_dataset, batch_size=None, shuffle=False)

    # Select network model
    if NETWORK_TYPE == 'mlp':

        model_ = model.SysID_MLP(
            INPUT_SIZE * SEQUENCE_LENGTH, HIDDEN_SIZE, NUM_LAYERS, OUTPUT_SIZE, dropout=DROPOUT)

    elif NETWORK_TYPE == 'rnn':

        model_ = model.SysID_RNN(INPUT_SIZE, HIDDEN_SIZE,
                                 OUTPUT_SIZE, NUM_LAYERS, dropout=DROPOUT)
    else:

        print('Invalid network type')
        exit()

    criterion_train = nn.CrossEntropyLoss(reduction='mean')
    criterion_test = nn.CrossEntropyLoss(reduction='sum')
    #optimizer = torch.optim.Adam(model_.parameters(), lr=0.01, betas=(0.9, 0.999), eps=1e-08, weight_decay=1e-4, amsgrad=False)
    optimizer = torch.optim.Adam(
        model_.parameters(), lr=5e-3,  weight_decay=0.000001)
    iter = 0

    print(model_)
    time.sleep(3)
    while True:

        train(model=model_, device=device, train_loader=train_dataset_loader, criterion=criterion_train,
              optimizer=optimizer, batch_size=BATCH_SIZE, epoch=NUM_EPOCHS, network_type=NETWORK_TYPE)

        evaluate(model=model_, device=device, test_loader=test_dataset_loader,
                 criterion=criterion_test, batch_size=BATCH_SIZE)

        iter += NUM_EPOCHS

        if np.mod(iter, 10000) == 0:

            dir_name = './model/model_' + NETWORK_TYPE + '_' + str(iter)
            path = dir_name + '/'
            try:
                os.mkdir(path)
            except FileExistsError:
                print('Directory already exists')

            model.save_model(model_, path + 'model.pt')
            model.save_optimizer(optimizer, path + 'optim.pt')
            model.save_criterion(criterion_train, path + 'loss.pt')
