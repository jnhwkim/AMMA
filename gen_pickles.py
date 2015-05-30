import scipy.io as scio
import pickle as pkl
import numpy as np
import scipy.sparse

path = 'pkl/'
path_to_mat = '/Volumes/Oculus/data/Pororo/mat/'
path_to_sub = '/Volumes/Oculus/data/Pororo/sub/'

def get_data(target = 'Pororo_ENGLISH2_1_3'):
	# load features
	feat = scio.loadmat(path_to_mat+target+'_vgg.mat')

	# load subtitles
	f = open(path_to_sub + target + '.sub', 'r')
	lines = f.readlines()
	sub = []
	feat_idx = 0;
	for line in lines:
		sub.append([line.lower().split('\n')[0], feat_idx])
		feat_idx = feat_idx + 1
	feat = np.array(feat['features'], dtype='f').transpose() # float32
	feat = scipy.sparse.csc_matrix(feat)
	return sub, feat

def gen_worddict(worddict = {}, target = 'Pororo_ENGLISH2'):
	# load subtitles
	f = open(path_to_sub + target + '.sub', 'r')
	lines = f.readlines()
	if 0 == len(worddict):
		max_val = 2
	else:
		max_val = max(worddict.iterkeys(), key=(lambda key: worddict[key]))
	for line in lines:
		for w in line.lower().split():
			if worddict.has_key(w):
				pass
			else:
				max_val = max_val + 1
				worddict[w] = max_val # TODO: sort by word count?
	return worddict

def gen_data_pkl(sub, feat, target = 'Pororo_ENGLISH2_1_3'):
	with open(path + target + '.pkl', 'wb') as f:
		pkl.dump(feat, f)
		pkl.dump(sub, f)

def gen_worddict_pkl(worddict):
	with open(path + 'dictionary.pkl', 'wb') as f:
		pkl.dump(worddict, f)

if __name__ == '__main__':
	feat, sub = get_data()
	gen_data_pkl(sub, feat)
	gen_worddict_pkl(gen_worddict())
