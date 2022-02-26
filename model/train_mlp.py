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


args = {}

if __name__ == '__main__':

    if torch.cuda.is_available():

        args['device'] = 'cuda:0'

    else:

        args['device'] = 'cpu'

    # Load the dataset
    #args['DATA_PATH'] = '/home/vaydingul20/Documents/RML/Haptics_Modelling/data/dfg/'
    #args['DATA_PATH'] = '/home/vaydingul20/Documents/RML/Measurements_and_Analyses/16.12.2021_New_Setup_Berke_RBS_Response_Dataset/dataset/'
    args['DATA_PATH'] = '/home/vaydingul20/Documents/RML/Measurements_and_Analyses/28.12.2021_New_Setup_Volkan_Modulated_RBS_Response_Dataset/dataset'

    args['BATCH_SIZE'] = 20000
    args['INPUT_SIZE'] = 4
    args['OUTPUT_SIZE'] = 2
    args['NUM_LAYERS'] = 11
    args['HIDDEN_SIZE'] = 2048
    args['SEQUENCE_LENGTH'] = 512
    args['NUM_EPOCHS'] = 1
    args['NUM_TRAINING'] = 100
    args['DOWNLOAD_PER_ITER'] = args['NUM_EPOCHS'] *args['NUM_TRAINING']
    args['NETWORK_TYPE'] = 'mlp'
    args['DROPOUT'] = 0.
    args['ANIMATE'] = True
    args['CONCAT_ALL'] = True
    args['X_DATA'] = ['accelerationX_', 'accelerationZ_', 'forceX_', 'forceZ_']
    #args['X_DATA'] = ['forceX_']
    args['Y_DATA'] = 'signal_'
    args['NUM_CLASSES'] = 2
    #args['X_DATA'] = ['normal_force']
    #args['Y_DATA'] = 'signal_save'

    args['MODEL_SAVE_PATH'] = './model/' + datetime.today().strftime('%Y-%m-%d-%H-%M-%S') + \
        '_' + args['NETWORK_TYPE'] + '/'

    args['TRAIN_TEST_SPLIT'] = 0.8
    args['TRAIN_DATASET_LOADER_SHUFFLE'] = True
    args['TEST_DATASET_LOADER_SHUFFLE'] = True
    args['TRAIN_DATASET_LOADER_BATCH_SIZE'] = None
    args['TEST_DATASET_LOADER_BATCH_SIZE'] = None
    args['DATASET_SEED'] = 42

    args['TRAIN_CRITERION_LOSS_FUNCTION'] = nn.CrossEntropyLoss
    args['TEST_CRITERION_LOSS_FUNCTION'] = nn.CrossEntropyLoss
    args['TRAIN_CRITERION_PARAMETERS'] = {'reduction': 'mean'}
    args['TEST_CRITERION_PARAMETERS'] = {'reduction': 'sum'}

    args['LEARNING_RATE'] = 5e-4
    args['OPTIMIZER'] = torch.optim.Adam
    args['OPTIMIZER_PARAMETERS'] = {'lr': args['LEARNING_RATE'], 'weight_decay': 1e-4}
    
    assert args['INPUT_SIZE'] == len(args['X_DATA'])
    assert args['OUTPUT_SIZE'] == args['NUM_CLASSES']


    train_dataset, test_dataset = dataset_util.generate_datasets(
        data_path=args['DATA_PATH'], x_data=args['X_DATA'], y_data=args['Y_DATA'], sequence_length=args['SEQUENCE_LENGTH'], num_class=args['NUM_CLASSES'], network_type=args['NETWORK_TYPE'], concat_all=args['CONCAT_ALL'], train_test_split=args['TRAIN_TEST_SPLIT'], seed = args['DATASET_SEED'])

    train_dataset_loader = torch.utils.data.DataLoader(
        train_dataset, batch_size=args['TRAIN_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TRAIN_DATASET_LOADER_SHUFFLE'])
    test_dataset_loader = torch.utils.data.DataLoader(
        test_dataset, batch_size=args['TEST_DATASET_LOADER_BATCH_SIZE'], shuffle=args['TEST_DATASET_LOADER_SHUFFLE'])


    model_ = model.SysID_MLP(
        args['INPUT_SIZE'] * args['SEQUENCE_LENGTH'], args['HIDDEN_SIZE'], args['NUM_LAYERS'], args['OUTPUT_SIZE'], dropout=args['DROPOUT'])


    criterion_train = args['TRAIN_CRITERION_LOSS_FUNCTION'](**args['TRAIN_CRITERION_PARAMETERS'])
    criterion_test = args['TEST_CRITERION_LOSS_FUNCTION'](**args['TEST_CRITERION_PARAMETERS'])
    optimizer = args['OPTIMIZER'](
        model_.parameters(), **args['OPTIMIZER_PARAMETERS'])

    iter = 0

    print(model_)
    time.sleep(1)

    os.mkdir(args['MODEL_SAVE_PATH'])

    args['train_loss_data'] = np.empty(0,)
    args['train_acc_data'] = np.empty(0,)
    args['test_loss_data'] = np.empty(0,)
    args['test_acc_data'] = np.empty(0,)

    while True:

        print("EPOCH ===>" + str(iter))
        if args['ANIMATE']:

            args['train_loss_data'], args['train_acc_data'], args['test_loss_data'], args['test_acc_data'] = animate_train_evaluate(
                model=model_, device=args['device'], train_loader=train_dataset_loader, test_loader=test_dataset_loader, criterion_train=criterion_train, criterion_test=criterion_test, optimizer=optimizer, batch_size=args['BATCH_SIZE'], epoch=args['NUM_EPOCHS'], num_training=args['NUM_TRAINING'])
            iter += args['NUM_EPOCHS'] * args['NUM_TRAINING']

        else:

            train_loss, train_acc, test_loss, test_acc = train_evaluate(model=model_, device=args['device'], train_loader=train_dataset_loader, test_loader=test_dataset_loader,
                                                                        criterion_train=criterion_train, criterion_test=criterion_test, optimizer=optimizer, batch_size=args['BATCH_SIZE'], epoch=args['NUM_EPOCHS'])

            args['train_loss_data'] = np.append(
                args['train_loss_data'], train_loss)
            args['train_acc_data'] = np.append(
                args['train_acc_data'], train_acc)
            args['test_loss_data'] = np.append(
                args['test_loss_data'], test_loss)
            args['test_acc_data'] = np.append(args['test_acc_data'], test_acc)

            iter += args['NUM_EPOCHS']

        if np.mod(iter, args['DOWNLOAD_PER_ITER']) == 0:

            dir_name = args['MODEL_SAVE_PATH'] + '/' + 'model_' + \
                args['NETWORK_TYPE'] + '_' + str(iter) + '/'

            try:

                os.mkdir(dir_name)

            except FileExistsError:

                print('Directory already exists')

            model.save_checkpoint(model_, optimizer, criterion_train, criterion_test, path=dir_name + "checkpoint.pt",
                                  args=args)

            args['train_loss_data'] = np.empty(0,)
            args['train_acc_data'] = np.empty(0,)
            args['test_loss_data'] = np.empty(0,)
            args['test_acc_data'] = np.empty(0,)
