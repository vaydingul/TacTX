import time

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import torch
import torch.functional as F
from colorama import Fore
from matplotlib.animation import FuncAnimation
from matplotlib.pyplot import legend, xlabel
from tqdm import tqdm, trange

matplotlib.use('Qt5Agg')

def train(model, device, train_loader, criterion, optimizer, batch_size, epoch):
    
    model.to(device)
    model.train()

    pbar = tqdm(range(epoch), colour = 'red')

    

    for epoch_idx in pbar:

        correct = 0
        processed = 0

        for trial_idx, (train_trial) in enumerate(train_loader):
            # get data loader for trial
            train_trial_loader = torch.utils.data.DataLoader(
                train_trial, batch_size=batch_size, shuffle=True, drop_last=False)

            

            for batch_idx, (data, target) in enumerate(train_trial_loader):

                data, target = data.to(device), target.to(device)

                # Init
                optimizer.zero_grad()
                # In PyTorch, we need to set the gradients to zero before starting to do backpropragation because PyTorch accumulates the gradients on subsequent backward passes.
                # Because of this, when you start your training loop, ideally you should zero out the gradients so that you do the parameter update correctly.

                # Predict

                y_pred = model(data).squeeze()

                # Calculate loss
                loss = criterion(y_pred, target)
                # PyTorch auto-differentiates the loss w.r.t. the parameters of the model for us, so we just need to call backward() to do the job.

                # Backpropagation
                loss.backward()

                optimizer.step()

                # Update pbar-tqdm
                #pred = torch.nn.functional.softmax(y_pred, dim=1).argmax(
                #    dim=1, keepdim=True)  # get the index of the max log-probability
                pred = y_pred.argmax(dim=1, keepdim=True)
                correct += pred.eq(target.view_as(pred)).sum().item()
                processed += len(data)
                accuracy = 100. * correct / processed

                pbar.set_description(
                    desc=Fore.GREEN + f'Loss={loss.item():.2f} Epoch = {epoch_idx+1} Trial_idx={trial_idx+1} Batch_idx={batch_idx+1} Accuracy={accuracy:.2f}')

    return loss, accuracy

def evaluate(model, device, test_loader, criterion, batch_size):

    model.eval()
    test_loss = 0
    correct = 0
    batch_counter = 0
    with torch.no_grad():

        for trial_idx, (test_trial) in enumerate(test_loader):
            # get data loader for trial
            test_trial_loader = torch.utils.data.DataLoader(
                test_trial, batch_size=batch_size, shuffle=True, drop_last=False)

            
            for batch_idx, (data, target) in enumerate(test_trial_loader):

                data, target = data.to(device), target.to(device)
                output = model(data)
                # sum up batch loss
                test_loss += criterion(output, target).item()
                # get the index of the max log-probability
                pred = output.argmax(dim=1, keepdim=True)
                #print(Fore.CYAN, sum(pred), pred.shape)
                correct += pred.eq(target.view_as(pred)).sum().item()

                batch_counter += data.shape[0]

    test_loss /= batch_counter

    test_accuracy = 100. * correct/batch_counter

    print(Fore.MAGENTA, '\nTest set: Average loss: {:.2f}, Accuracy: {}/{} ({:.2f}%)\n'.format(
        test_loss, correct, batch_counter,
        test_accuracy))

    return test_loss, test_accuracy



def inference_one_random_sample(model, device, test_loader, batch_size = 1000):
    
    model.eval()

    len_test_loader = len(test_loader)
    idx = np.random.randint(0, len_test_loader)

    with torch.no_grad():

        for trial_idx, (test_trial) in enumerate(test_loader):

                if trial_idx == idx:
                # get data loader for trial

                    test_trial_loader = torch.utils.data.DataLoader(
                        test_trial, batch_size=batch_size, shuffle=False, drop_last=False)
                    len_test_trial_loader = len(test_trial_loader)
                    idx_batch = np.random.randint(0, len_test_trial_loader)
                    
                    for batch_idx, (data, target) in enumerate(test_trial_loader):
                        
                        if batch_idx == idx_batch:

                            data, target = data.to(device), target.to(device)
                            output = model(data)
                            # get the index of the max log-probability
                            pred = output.argmax(dim=1, keepdim=True)
                            target_ = target
                           
    return pred, target_

def train_evaluate(model, device, train_loader, test_loader, criterion_train, criterion_test, optimizer, batch_size, epoch):

    train_loss, train_acc = train(model=model, device=device, train_loader=train_loader, criterion=criterion_train,
            optimizer=optimizer, batch_size=batch_size, epoch=epoch)

    test_loss, test_acc = evaluate(model=model, device=device, test_loader=test_loader,
                criterion=criterion_test, batch_size=batch_size)

    return train_loss, train_acc, test_loss, test_acc

def animate_train_evaluate(model, device, train_loader, test_loader, criterion_train, criterion_test, optimizer, batch_size, epoch, num_training):


    #plt.style.use('dark_background')
    plt.xkcd()
    fig = plt.figure(figsize = (10, 10))
    spec = fig.add_gridspec(ncols=2, nrows=3)

    ax_train_loss = fig.add_subplot(spec[0, 0], title='Training Loss', xlabel = 'Epoch', ylabel = 'Loss')
    ax_train_acc = fig.add_subplot(spec[0, 1], title='Training Accuracy', xlabel = 'Epoch', ylabel = 'Accuracy')
    ax_test_loss = fig.add_subplot(spec[1, 0], title='Test Loss', xlabel = 'Epoch', ylabel = 'Loss')
    ax_test_acc = fig.add_subplot(spec[1, 1], title='Test Accuracy', xlabel = 'Epoch', ylabel = 'Accuracy')
    ax_inference = fig.add_subplot(spec[2, :], title='Inference', xlabel = 'Data Point', ylabel = 'Signal')

    train_loss_line,  = ax_train_loss.plot([], [], marker = 'o', c = 'r')
    train_acc_line,  = ax_train_acc.plot([], [], marker = '^', c = 'g')
    test_loss_line,  = ax_test_loss.plot([], [], marker = 'o', c = 'r')
    test_acc_line,  = ax_test_acc.plot([], [], marker = '^', c = 'g')
    inference_line_pred  = ax_inference.stairs([], label = 'Prediction')
    inference_line_target  = ax_inference.stairs([], label = 'Target')
    inference_line_pred.set(linewidth = 3)



    def init():


        train_loss_line.set_data([], [])
        train_acc_line.set_data([], [])
        test_loss_line.set_data([], [])
        test_acc_line.set_data([], [])
        inference_line_pred.set_data([])
        inference_line_target.set_data([])
        return train_loss_line, train_acc_line, test_loss_line, test_acc_line, inference_line_pred, inference_line_target, ax_train_loss, ax_train_acc, ax_test_loss, ax_test_acc, ax_inference,


    def animate(i):
        
        #print(i)
        if i == num_training: 
            
            time.sleep(5.0)
            plt.close(fig)

        train_loss, train_acc, test_loss, test_acc = train_evaluate(model=model, device=device, train_loader=train_loader, test_loader=test_loader, criterion_train=criterion_train, criterion_test=criterion_test, optimizer=optimizer, batch_size=batch_size, epoch=epoch)
        random_sample_pred, random_sample_target = inference_one_random_sample(model = model, device = device, test_loader = test_loader)


        train_loss_line.set_ydata(np.hstack([train_loss_line.get_ydata(), train_loss.item()]))
        train_loss_line.set_xdata(np.hstack([train_loss_line.get_xdata(), i * epoch]))

        train_acc_line.set_ydata(np.hstack([train_acc_line.get_ydata(), train_acc]))
        train_acc_line.set_xdata(np.hstack([train_acc_line.get_xdata(), i * epoch]))
        test_loss_line.set_ydata(np.hstack([test_loss_line.get_ydata(), test_loss]))
        test_loss_line.set_xdata(np.hstack([test_loss_line.get_xdata(), i * epoch]))

        test_acc_line.set_ydata(np.hstack([test_acc_line.get_ydata(), test_acc]))
        test_acc_line.set_xdata(np.hstack([test_acc_line.get_xdata(), i * epoch]))

        inference_line_pred.set_data(random_sample_pred.view(-1).cpu().detach().numpy(), np.arange(0, random_sample_pred.shape[0]+1))

        inference_line_target.set_data(random_sample_target.view(-1).cpu().detach().numpy(), np.arange(0, random_sample_target.shape[0]+1))

        ax_train_loss.set_xlim(0, (i + 1) * epoch)
        ax_train_loss.set_ylim(0, max(train_loss_line.get_ydata()) * 1.1)
        ax_train_acc.set_xlim(0, (i + 1) * epoch)
        ax_train_acc.set_ylim(0, 100)
        ax_test_loss.set_xlim(0, (i + 1) * epoch)
        ax_test_loss.set_ylim(0, max(test_loss_line.get_ydata()) * 1.1)
        ax_test_acc.set_xlim(0, (i + 1) * epoch)
        ax_test_acc.set_ylim(0, 100)
        ax_inference.set_xlim(0, random_sample_pred.shape[0])
        ax_inference.set_ylim(-1, 3)
        ax_inference.legend()

        fig.suptitle('Epoch: {}'.format(i * epoch))

        return train_loss_line, train_acc_line, test_loss_line, test_acc_line, inference_line_pred, inference_line_target, ax_train_loss, ax_train_acc, ax_test_loss, ax_test_acc, ax_inference,

    animation = FuncAnimation(fig = fig, func = animate, init_func=init, frames= np.arange(1, num_training + 1), repeat = False) 
    fig.tight_layout()
    plt.show()

    return train_loss_line.get_ydata(), train_acc_line.get_ydata(), test_loss_line.get_ydata(), test_acc_line.get_ydata()
