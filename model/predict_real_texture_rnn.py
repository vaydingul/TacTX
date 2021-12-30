from torch.nn.modules import dropout
import model
import dataset_util
from process import animate_train_evaluate, train, evaluate, train_evaluate, inference_one_random_sample, inference_one_trial
from torch import nn
import torch
from datetime import datetime
import os
import numpy as np
import time


import matplotlib.pyplot as plt




if __name__ == '__main__':

    main_folder = "2021-12-30-00-10-50_rnn/"
    model_folder = "model_rnn_16/"
    checkpoint_path = "/home/vaydingul20/Documents/RML/TacTX/model/" + main_folder + model_folder + "/checkpoint.pt"
    real_texture_path =  '/home/vaydingul20/Documents/RML/Measurements_and_Analyses/30.12.2021_New_Setup_Real_Texture_Measurement_Red_Fabric_Dataset/dataset'
 
    state = torch.load(checkpoint_path)

    args = state['args']


    for (k, v) in args.items():
        print(k, ' -> ', v)

    if torch.cuda.is_available():

        args['device'] = 'cuda:0'

    else:

        args['device'] = 'cpu'
    
    args['TRAIN_TEST_SPLIT'] = 1.0
    args['CONCAT_ALL'] = False

    train_dataset, _ = dataset_util.generate_datasets(
        real_texture_path, x_data = args['X_DATA'], y_data = args['Y_DATA'], sequence_length=args['SEQUENCE_LENGTH'], network_type=args['NETWORK_TYPE'], concat_all=args['CONCAT_ALL'], train_test_split=args['TRAIN_TEST_SPLIT'])

 
    train_dataset_loader = torch.utils.data.DataLoader(
        train_dataset, batch_size=args['TRAIN_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TRAIN_DATASET_LOADER_SHUFFLE'])
    
    #test_dataset_loader = torch.utils.data.DataLoader(
    #    test_dataset, batch_size=args['TEST_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TEST_DATASET_LOADER_SHUFFLE'])

    

    model_ = model.SysID_RNN(args['RNN_TYPE'], args['RNN_PARAMETERS'],
        args['INPUT_SIZE'], args['HIDDEN_SIZE'], args['OUTPUT_SIZE'], args['NUM_LAYERS'], dropout=args['DROPOUT'])


    criterion_train = args['TRAIN_CRITERION_LOSS_FUNCTION'](**args['TRAIN_CRITERION_PARAMETERS'])
    criterion_test = args['TEST_CRITERION_LOSS_FUNCTION'](**args['TEST_CRITERION_PARAMETERS'])
    optimizer = args['OPTIMIZER'](
        model_.parameters(), **args['OPTIMIZER_PARAMETERS'])

    iter = 0

    model_.load_state_dict(state['model'])
    optimizer.load_state_dict(state['optimizer'])
    criterion_train.load_state_dict(state['criterion_train'])
    criterion_test.load_state_dict(state['criterion_test'])
    
    print(model_)
    time.sleep(1)


    model_.to(args['device'])
    batch_size = 1000
    
    for trial_idx, (test_trial) in enumerate(train_dataset_loader):

           
        train_trial_loader = torch.utils.data.DataLoader(
            test_trial, batch_size=batch_size, shuffle=False, drop_last=False)

        predicted = inference_one_trial(model = model_, device = args['device'], test_trial_loader = train_trial_loader)


    plt.figure()
    plt.plot(predicted.cpu(), label = 'predicted')
    #plt.plot(target.cpu(), label = 'target')
    plt.legend()
    plt.show()

   