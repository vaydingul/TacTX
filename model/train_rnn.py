from torch.nn.modules import dropout
import model
import dataset_util
from process import animate_train_evaluate, train, evaluate, train_evaluate
from torch import nn
import torch
from datetime import datetime
import os
import numpy as np
import time




if __name__ == '__main__':

    if torch.cuda.is_available():

        device = 'cuda:0'

    else:

        device = 'cpu'

    # Load the dataset
    #DATA_PATH = '/home/vaydingul20/Documents/RML/Haptics_Modelling/data/asd/'
    DATA_PATH = '/home/vaydingul20/Documents/RML/Measurements_and_Analyses/16.12.2021_New_Setup_Berke_PRBS_Response_Dataset/dataset/'
    # Batch size
    BATCH_SIZE = 500
    INPUT_SIZE = 2
    OUTPUT_SIZE = 2
    NUM_LAYERS = 2
    HIDDEN_SIZE = 256
    SEQUENCE_LENGTH = 511
    NUM_EPOCHS = 1
    NUM_TRAINING = 100
    DOWNLOAD_PER_ITER = NUM_EPOCHS * NUM_TRAINING
    NETWORK_TYPE = 'rnn'
    DROPOUT = 0.
    ANIMATE = True
    CONCAT_ALL = False

    train_dataset, test_dataset = dataset_util.generate_datasets(
        data_path=DATA_PATH, x_data = ["accelerationX_", "accelerationZ_"], y_data = "signal_", sequence_length=SEQUENCE_LENGTH, network_type=NETWORK_TYPE, concat_all=CONCAT_ALL, train_test_split=0.8)

    #train_dataset, test_dataset = dataset_util.generate_datasets(
    #    data_path=DATA_PATH, x_data = ["forceX_", "forceZ_", "accelerationX_", "accelerationZ_"], y_data = "signal_", sequence_length=SEQUENCE_LENGTH, network_type=NETWORK_TYPE, concat_all=CONCAT_ALL, train_test_split=0.8)


    #train_dataset, test_dataset = dataset_util.generate_datasets(
    #    data_path=DATA_PATH, x_data = ["normal_force"], y_data = "signal_save", sequence_length=SEQUENCE_LENGTH, network_type=NETWORK_TYPE, concat_all=CONCAT_ALL, train_test_split=0.8)

    train_dataset_loader = torch.utils.data.DataLoader(
        train_dataset, batch_size=None, shuffle=True)
    test_dataset_loader = torch.utils.data.DataLoader(
        test_dataset, batch_size=None, shuffle=True)

    # Select network model
    

    model_ = model.SysID_RNN(
        INPUT_SIZE, HIDDEN_SIZE, OUTPUT_SIZE, NUM_LAYERS, dropout=DROPOUT)


    criterion_train = nn.CrossEntropyLoss(reduction='mean')
    criterion_test = nn.CrossEntropyLoss(reduction='sum')
    optimizer = torch.optim.Adam(
        model_.parameters(), lr=5e-3, weight_decay=1e-4)

    iter = 0

    print(model_)
    time.sleep(1)

        
    while True:

        if ANIMATE:

            train_loss_data, train_acc_data, test_loss_data, test_acc_data =animate_train_evaluate(model = model_, device = device, train_loader = train_dataset_loader, test_loader = test_dataset_loader, criterion_train=criterion_train, criterion_test=criterion_test, optimizer=optimizer, batch_size = BATCH_SIZE, epoch=NUM_EPOCHS, num_training=NUM_TRAINING)
            iter += NUM_EPOCHS * NUM_TRAINING

        else:

            train_evaluate(model = model_, device = device, train_loader = train_dataset_loader, test_loader = test_dataset_loader, criterion_train=criterion_train, criterion_test=criterion_test, optimizer=optimizer, batch_size = BATCH_SIZE, epoch=NUM_EPOCHS)
            iter += NUM_EPOCHS
        

        if np.mod(iter, DOWNLOAD_PER_ITER) == 0:

            dir_name = './model/' + datetime.today().strftime('%Y-%m-%d-%H:%M:%S') +  '_model_' + NETWORK_TYPE + '_' + str(iter)
            path = dir_name + '/'
            try:

                os.mkdir(path)

            except FileExistsError:

                print('Directory already exists')

            model.save(model_, optimizer, criterion_train, path)
            model.save_criterion(criterion_test, path + 'test_loss.pt')
            model.save_history(train_loss_data, train_acc_data, test_loss_data, test_acc_data, path + "history.pt")
            #model.save_model(model_, path + 'model.pt')
            #model.save_optimizer(optimizer, path + 'optim.pt')
            #model.save_criterion(criterion_train, path + 'loss.pt')

