from torch.nn.modules import dropout
import model
import dataset_util
from process import animate_train_evaluate, train, evaluate, train_evaluate, inference_one_random_sample
from torch import nn
import torch
from datetime import datetime
import os
import numpy as np
import time
import matplotlib.pyplot as plt





if __name__ == '__main__':

    main_folder = "2021-12-23-19-07-18_mlp/"
    model_folder = "model_mlp_400/"
    checkpoint_path = "/home/vaydingul20/Documents/RML/TacTX/model/" + main_folder + model_folder + "/checkpoint.pt"

    state = torch.load(checkpoint_path)

    args = state['args']


    for (k, v) in args.items():
        print(k, ' -> ', v)


    if torch.cuda.is_available():

        args['device'] = 'cuda:0'

    else:

        args['device'] = 'cpu'


    train_dataset, test_dataset = dataset_util.generate_datasets(
        data_path=args['DATA_PATH'], x_data=args['X_DATA'], y_data=args['Y_DATA'], sequence_length=args['SEQUENCE_LENGTH'], num_class=args['NUM_CLASSES'], network_type=args['NETWORK_TYPE'], concat_all=args['CONCAT_ALL'], train_test_split=args['TRAIN_TEST_SPLIT'], seed = args['DATASET_SEED'])

    #train_dataset, test_dataset = dataset_util.generate_datasets(
    #    data_path=DATA_PATH, x_data = ["forceX_", "forceZ_", "accelerationX_", "accelerationZ_"], y_data = "signal_", sequence_length=SEQUENCE_LENGTH, network_type=NETWORK_TYPE, concat_all=CONCAT_ALL, train_test_split=0.8)

    train_dataset_loader = torch.utils.data.DataLoader(
        train_dataset, batch_size=args['TRAIN_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TRAIN_DATASET_LOADER_SHUFFLE'])
    test_dataset_loader = torch.utils.data.DataLoader(
        test_dataset, batch_size=args['TEST_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TEST_DATASET_LOADER_SHUFFLE'])

    # Select network model
    

    model_ = model.SysID_MLP(
        args['INPUT_SIZE'] * args['SEQUENCE_LENGTH'], args['HIDDEN_SIZE'], args['NUM_LAYERS'], args['OUTPUT_SIZE'], dropout=args['DROPOUT'])


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
    predicted, target = inference_one_random_sample(model = model_, device = args['device'], test_loader = train_dataset_loader, batch_size = 2000)
    plt.figure()
    plt.plot(predicted.cpu(), label = 'predicted')
    plt.plot(target.cpu(), label = 'target')
    plt.legend()
    plt.show()

    