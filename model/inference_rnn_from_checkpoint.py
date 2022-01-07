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

    main_folder = "2021-12-30-05-59-39_rnn/"
    model_folder = "model_rnn_15/"
    checkpoint_path = "/home/vaydingul20/Documents/RML/TacTX/model/" + \
        main_folder + model_folder + "/checkpoint.pt"

    state = torch.load(checkpoint_path)

    args = state['args']

    for (k, v) in args.items():
        print(k, ' -> ', v)

    exit()
    if torch.cuda.is_available():

        args['device'] = 'cuda:0'

    else:

        args['device'] = 'cpu'

    args['CONCAT_ALL'] = False

    train_dataset, test_dataset = dataset_util.generate_datasets(
        data_path=args['DATA_PATH'], x_data=args['X_DATA'], y_data=args['Y_DATA'], sequence_length=args['SEQUENCE_LENGTH'], num_class=args['NUM_CLASSES'], network_type=args['NETWORK_TYPE'], concat_all=args['CONCAT_ALL'], train_test_split=args['TRAIN_TEST_SPLIT'], seed = args['DATASET_SEED'])

    train_dataset_loader = torch.utils.data.DataLoader(
        train_dataset, batch_size=args['TRAIN_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TRAIN_DATASET_LOADER_SHUFFLE'])
    test_dataset_loader = torch.utils.data.DataLoader(
        test_dataset, batch_size=args['TEST_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TEST_DATASET_LOADER_SHUFFLE'])

    # Select network model

    model_ = model.SysID_RNN(args['RNN_TYPE'], args['RNN_PARAMETERS'],
                             args['INPUT_SIZE'], args['HIDDEN_SIZE'], args['OUTPUT_SIZE'], args['NUM_LAYERS'], dropout=args['DROPOUT'])

    criterion_train = args['TRAIN_CRITERION_LOSS_FUNCTION'](
        **args['TRAIN_CRITERION_PARAMETERS'])
    criterion_test = args['TEST_CRITERION_LOSS_FUNCTION'](
        **args['TEST_CRITERION_PARAMETERS'])
    optimizer = args['OPTIMIZER'](
        model_.parameters(), **args['OPTIMIZER_PARAMETERS'])

    iter = 0

    model_.load_state_dict(state['model'])
    optimizer.load_state_dict(state['optimizer'])
    criterion_train.load_state_dict(state['criterion_train'])
    criterion_test.load_state_dict(state['criterion_test'])

    print(model_)
    time.sleep(1)

    """
    model_.to(args['device'])
    predicted, target = inference_one_random_sample(model = model_, device = args['device'], test_loader = test_dataset_loader, batch_size = 2000)
    
    
    plt.figure()
    plt.plot(predicted.cpu(), label = 'predicted')
    plt.plot(target.cpu(), label = 'target')
    plt.legend()
    plt.show()
    """

    model_.to(args['device'])
    batch_size = 1000

    for trial_idx, (test_trial) in enumerate(train_dataset_loader):

        train_trial_loader = torch.utils.data.DataLoader(
            test_trial, batch_size=batch_size, shuffle=False, drop_last=False)

        data, target, predicted = inference_one_trial(
            model=model_, device=args['device'], test_trial_loader=train_trial_loader)
        break

    title_dict = {'accelerationX_': '$a_{tangential}$',
                  'accelerationZ_': '$a_{normal}$',
                  'forceX_': '$F_{tangential}$',
                  'forceZ_': '$F_{normal}$'}

    fig = plt.figure()

    for x in range(data.shape[2]):

        plt.subplot(5, 1, x+1, title=title_dict[args['X_DATA'][x]])
        plt.plot(data[:, int((args['SEQUENCE_LENGTH']-1)/2),
                 x].cpu())

    plt.subplot(5, 1, 5, title = 'Signal')
    plt.plot(target.cpu(), label='target', lw = 5)
    plt.plot(predicted.cpu(), label='predicted')
    plt.legend()
    fig.tight_layout()
    plt.show()
